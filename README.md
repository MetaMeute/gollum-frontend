### Authentication

This gollum supports authenticated users using LDAP. To activate authentication
set :ldap, e.g.:

    Precious::App.set(:ldap, {
        :host => "10.130.0.8",
        :port => 389,
        :base => "cn=%s,ou=People,dc=metameute,dc=de"
      }
    )

### Private Wikis

You may also set a wiki to be private, i.e. it can only be edited by
authenticated users.

    Precious::App.set(:private, true)

