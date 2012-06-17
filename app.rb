require 'cgi'
require 'sinatra'
require 'rubygems'
require 'net/ldap'
require 'gollum'
require 'mustache/sinatra'

require 'gollum/frontend/views/layout'
require 'gollum/frontend/views/editable'

module Precious
  class App < Sinatra::Base
    register Mustache::Sinatra

    helpers do
      def protected!
        return unless settings.respond_to?('private')

        redirect "/login" unless authorized?
      end

      def authorized?
        @session.include? :username
      end

      def may_login
        settings.respond_to?('ldap')
      end

      def auth(username, pass)
        return nil unless may_login

        user = settings.ldap[:base] % username

        ldap = Net::LDAP.new :host => settings.ldap[:host],
          :port => settings.ldap[:port], :auth => {
            :method => :simple, 
            :username => user, 
            :password => pass
        }

        return nil unless ldap.bind

        account = ldap.search( :base => user).first

        cn = account[:cn].first

        email = ""

        return {:username => cn, :email => email}
      end

      def spamfilter!(params)
        score = 0
        message = params[:message]
        score += 1.0 if not params[:email].empty?
        score += 0.8 if message.include? "<a "
        score += 0.8 if message.include? "[url="
        score += 0.8 if message.include? "[link="
        score += 0.2 if message.include? "http"

        redirect "/" if score >= 1.0
      end
    end

    dir = File.dirname(File.expand_path(__FILE__))

    # We want to serve public assets for now
    set :public_folder, "#{dir}/public"
    set :static,         true

    set :mustache, {
      # Tell mustache where the Views constant lives
      :namespace => Precious,

      # Mustache templates live here
      :templates => "#{dir}/templates",

      # Tell mustache where the views are
      :views => "#{dir}/views"
    }

    # Sinatra error handling
    configure :development, :staging do
      enable :show_exceptions, :dump_errors
      disable :raise_errors, :clean_trace
    end

    configure :test do
      enable :logging, :raise_errors, :dump_errors
    end

    enable :sessions

    before do
      @session = session
      @may_login = may_login
    end

    get '/' do
      show_page_or_file('Home')
    end

    get '/login' do
      halt 404 unless may_login

      # show login page
      mustache :login
    end

    post '/login' do
      halt 404 unless may_login

      # attempt to login user using params[:login] and params[:password]
      # and sets session[:username] and session[:email] on success
      #
      #
      # login failed. redirect to /login and add a message
      
      session.clear

      result = auth(params[:login], params[:password])

      halt 401 if result.nil?

      session[:username] = result[:username]
      session[:email] = result[:email]
      
      redirect "/"
    end

    get '/logout' do
      # log user out, clear session
      session.clear 
      mustache :logout
    end

    get '/edit/*' do
      protected!
      @name = CGI.unescape(params[:splat].first)
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      if page = wiki.page(@name)
        @page = page
        @content = page.raw_data
        mustache :edit
      else
        mustache :create
      end
    end

    post '/edit/*' do
      protected!
      spamfilter!(params)
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      page = wiki.page(params[:splat].first)
      name = params[:rename] || page.name
      committer = Gollum::Committer.new(wiki, commit_message)
      commit    = {:committer => committer}

      update_wiki_page(wiki, page, params[:content], commit, name,
        params[:format])
      update_wiki_page(wiki, page.header,  params[:header],  commit) if params[:header]
      update_wiki_page(wiki, page.footer,  params[:footer],  commit) if params[:footer]
      update_wiki_page(wiki, page.sidebar, params[:sidebar], commit) if params[:sidebar]
      committer.commit

      redirect "/#{CGI.escape(Gollum::Page.cname(name))}"
    end

    post '/create' do
      protected!
      name = params[:page]
      spamfilter!(params)
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)

      format = params[:format].intern

      begin
        wiki.write_page(name, format, params[:content], commit_message)
        redirect "/#{CGI.escape(name)}"
      rescue Gollum::DuplicatePageError => e
        @message = "Duplicate page: #{e.message}"
        mustache :error
      end
    end

    post '/revert/:page/*' do
      protected!
      wiki  = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @name = params[:page]
      @page = wiki.page(@name)
      shas  = params[:splat].first.split("/")
      sha1  = shas.shift
      sha2  = shas.shift

      if wiki.revert_page(@page, sha1, sha2, commit_message)
        redirect "/#{CGI.escape(@name)}"
      else
        sha2, sha1 = sha1, "#{sha1}^" if !sha2
        @versions = [sha1, sha2]
        diffs     = wiki.repo.diff(@versions.first, @versions.last, @page.path)
        @diff     = diffs.first
        @message  = "The patch does not apply."
        mustache :compare
      end
    end

    post '/preview' do
      wiki      = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @name     = "Preview"
      @page     = wiki.preview_page(@name, params[:content], params[:format])
      @content  = @page.formatted_data
      @editable = false
      mustache :page
    end

    get '/history/:name' do
      @name     = CGI.unescape(params[:name])
      wiki      = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @page     = wiki.page(@name)
      @page_num = [params[:page].to_i, 1].max
      @versions = @page.versions :page => @page_num
      mustache :history
    end

    post '/compare/:name' do
      @versions = params[:versions] || []
      if @versions.size < 2
        redirect "/history/#{CGI.escape(params[:name])}"
      else
        redirect "/compare/%s/%s...%s" % [
          CGI.escape(params[:name]),
          @versions.last,
          @versions.first]
      end
    end

    get '/compare/:name/:version_list' do
      @name     = CGI.unescape(params[:name])
      @versions = params[:version_list].split(/\.{2,3}/)
      wiki      = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @page     = wiki.page(@name)
      diffs     = wiki.repo.diff(@versions.first, @versions.last, @page.path)
      @diff     = diffs.first
      mustache :compare
    end

    get '/_tex.png' do
      content_type 'image/png'
      formula = Base64.decode64(params[:data])
      Gollum::Tex.render_formula(formula)
    end

    get %r{^/(javascript|css|images)} do
      halt 404
    end

    get %r{/(.+?)/([0-9a-f]{40})} do
      name = CGI.unescape(params[:captures][0])
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      if page = wiki.page(name, params[:captures][1])
        @page = page
        @name = name
        @content = page.formatted_data
        @editable = true
        mustache :page
      else
        halt 404
      end
    end

    get '/search' do
      @query = params[:q]
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @results = wiki.search @query
      @name = @query
      mustache :search
    end

    get '/pages' do
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      @results = wiki.pages
      @ref = wiki.ref
      mustache :pages
    end

    get '/*' do
      show_page_or_file(CGI.unescape(params[:splat].first))
    end

    not_found do
      @error = "404 - Page Not Found"
      @message = "The requested page could not be found."
      mustache :error
    end

    error 401 do
      @error = "401 - Not Authorized"
      @message = "Please login before accessing this page."
      mustache :error
    end

    def show_page_or_file(name)
      wiki = Gollum::Wiki.new(settings.gollum_path, settings.wiki_options)
      if page = wiki.page(name)
        @page = page
        @name = name
        @content = page.formatted_data
        @editable = true
        mustache :page
      elsif file = wiki.file(name)
        content_type file.mime_type
        file.raw_data
      else
        @name = name
        mustache :create
      end
    end

    def update_wiki_page(wiki, page, content, commit_message, name = nil, format = nil)
      return if !page ||
        ((!content || page.raw_data == content) && page.format == format)
      name    ||= page.name
      format    = (format || page.format).to_sym
      content ||= page.raw_data
      wiki.update_page(page, name, format, content.to_s, commit_message)
    end

    def commit_message
      msg = { :message => params[:message] }
      if session.include? :username
        msg[:name] = session[:username]
        msg[:email] = session[:email]
      end
      
      msg
    end
  end
end
