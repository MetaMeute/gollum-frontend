/*
 *  ../SourceForge/trunk/mathjax/jax/output/HTML-CSS/autoload/menclose.js
 *  
 *  Copyright (c) 2010 Design Science, Inc.
 *
 *  Part of the MathJax library.
 *  See http://www.mathjax.org for details.
 * 
 *  Licensed under the Apache License, Version 2.0;
 *  you may not use this file except in compliance with the License.
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 */

MathJax.Unpack([
  ['(','function(','a,b','){var ','d="1.0";var c="http://www.w3.org/2000/svg";var f="urn:schemas-microsoft-com:vml";var e="mjxvml";a.menclose.Augment({toHTML:',1,'K',3,'h','=this.getValues("','notation","','thickness','","','padding','","mathcolor","color");if(h.color&&!this','.mathcolor){h.mathcolor','=h.color}if(h.',11,'==null){h.',11,'=".075em"}if(h.',13,18,13,'=".2em"}var F','=b.length2em(h.',13,');var y',25,11,');var u=b.Em(y)+" solid";K=this.HTMLcreateSpan(K);var r=b.createStack(K);var o=b.createBox(r);this.HTMLmeasureChild(0,o);var w=o.bbox.h+F+y,A=o.bbox.d+F+y,j=o.bbox.w+2*(F+y);var z','=b.createFrame(','r,w+A,0,j,y,"none");z.id="','MathJax-frame-"+this.spanID',';','b.addBox(r,','z);r.insertBefore(z,o);var k=h.notation.split(/ /);var l=0,E=0,n=0,s=0,x=0,v=0;var C,g;if(!h',15,'="black"}else{K.style.color=h.mathcolor}for(var J=0,I=k.length;J<I;J++){switch(k[J]){','case a.NOTATION.','BOX',':z.style.','border','=u;if(!b.msieBorderWidthBug){','l=E=s=n=y}','break;case a.NOTATION.','ROUNDEDBOX',':if(b.useVML){if(!g){g=this.HTMLvml(r,w,A,j,y,h.mathcolor)}this.HTMLvmlElement(g,"','roundrect",{style:{width:','this.HTMLpx(','j-2*y),height:',49,'w+A-2*y','),left:',49,'y)+0.5',',top:',49,55,'},arcsize:".25"})}','else{if(!C){C=this.HTMLsvg(r,w,A,j,y,h.mathcolor)}this.HTMLsvgElement(C.firstChild,"','rect",{x:1,y:1,width:',49,'j-y)-1,height:',49,'w+A-y',')-1,rx:',49,'Math.min(w+A,j)/4)})}',45,'CIRCLE',47,'oval",{style:{width:',49,'j-2*y),height:',49,52,'),left:',49,55,',top:',49,55,'}})}',60,'ellipse",{rx:',49,'j/2-y),ry:','this.HTMLpx((w+A)/2','-y),cx:',49,'j/2),cy:',88,')})}',45,'LEFT',41,'borderLeft',43,'s=y}',45,'ACTUARIAL',41,'borderTop',43,'l=y;z.bbox.w+=F-y}',39,'RIGHT',41,'borderRight',43,'n=y}',45,'VERTICALSTRIKE:var q','=b.createRule(r,',65,'/2,0,y);',35,'q',');b.placeBox(','q,F+y+o.bbox.w/2,-','A,true);',45,'TOP',41,'borderTop',43,'l=y}',45,'BOTTOM',41,'borderBottom',43,'E=y}',45,'HORIZONTALSTRIKE:var G',114,'y,0,j-y/2);',35,'G',119,'G,0,(w+A)/2-',121,45,'UPDIAGONALSTRIKE',47,'line",{from:"0',',"+',49,65,'),to:',49,'j)+",0"})}',60,'line",{x1:1,y1:',49,65,'),x2:',49,'j-y),y2:',49,'y)})}',45,'DOWNDIAGONALSTRIKE',47,146,',0",to:',49,'j)+","+',49,'w+A-y)})}',60,'line",{x1:1,y1:',49,'y),x2:',49,'j-y),y2:',49,170,45,'MADRUWB',41,'borderBottom=u;z.style.borderRight',43,'E=n=y}',45,'RADICAL',47,'polyline",{points:',49,'y/2)+","+',49,'0.6*(w+A))+" "+',49,'F)+","+',49,65,')+" "+',49,'2*F)+","+',49,'y/2)+" "+',49,'j)+","+',49,'y/2)});x=F}',60,'path",{d:"M',' 1,"+',49,'0.6*(w+A))+" L "+',49,'F)+","+',49,'w+A)+" L "+',49,'2*F)+",1 L "+',49,'j)+",1"});','b.placeBox(C.parentNode,0,','F/2-',121,'x=F;v=y}',45,'LONGDIV',47,146,',"+',49,'y/2),to:',49,'j-y)+","+',49,'y/2)});this.HTMLvmlElement(g,"arc",{style:{width:',49,'2*F),height:',49,52,'),left:this.HTMLpx(-F),top:',49,'y)},startangle:"10",endangle:"170"});x=F}',60,207,' "+',49,'j)+",1 L 1,1 a"+',49,'F)+","+',88,'-y)+" 0 0,1 1,"+',49,52,')});',219,'y-',121,'x=F;v=y}break}}z','.style.width=b.Em(','j-s-n);z','.style.height=b.Em(','w+A-l-E',119,'z,0,v-A,true',119,'o,x+F+y,0);this.HTMLhandleSpace(K);this.','HTMLhandleColor','(K);return K},HTMLpx:',1,'g){return(g*b.em)},',265,':',1,'h',3,'i=document.getElementById("',33,');if(i',3,'g',9,'mathbackground','","background");if(this.style&&h','.style.backgroundColor','){g.',280,'=h',282,'}if(g.background&&!this.',280,'){g.',280,'=g.background}if(g.',280,'&&g.',280,'!==a.COLOR.TRANSPARENT){i',282,'=g.',280,'}}else{this.SUPER(arguments).',265,'.call(this,h)}},HTMLsvg:',1,'h,l,m,g,k,j',3,'i','=document.createElementNS(c',',"svg");if(i.style){i',257,'g);i',259,'l+m)}var n=b.createBox(h);n.appendChild(i',119,'n,0,-m,true);this.HTMLsvgElement(i,"g",{fill:"none",stroke:j,"stroke-width":k*b.em});return i},HTMLsvgElement:',1,'g,h,i',3,'j',306,',h);if(i){for(var k in i){if(i.hasOwnProperty(k)){j.setAttributeNS(null,k,i[k].toString())}}}g.appendChild(j);return j},HTMLvml:',1,'i,l,m,h,k,j',3,'g',31,'i,l+m,0,h,0,"none");b.addBox(i,g',119,'g,0,-m,true);','this.constructor.','VMLcolor=j;',328,'VMLthickness','=',49,'k);return g},HTMLvmlElement:',1,'g,h,i',3,'j=b.addElement(g,e+":"+h,i);if(!i.fillcolor){j.fillcolor="none"}if(!i.strokecolor){j.strokecolor=',328,'VMLcolor}if(!i.strokeweight){j.strokeweight=',328,331,'}}});MathJax.Hub.Browser.Select({MSIE:',1,'g){b.useVML=true;if(!','document.namespaces','[e]){',346,'.add(e,f);var h=document.createStyleSheet();h.addRule(e+"\\\\:*","{behavior: url(#default#VML); position:absolute; top:0; left:0}")}}});MathJax.Hub.Startup.signal.Post("HTML-CSS menclose Ready");MathJax.Ajax.loadComplete(b.autoloadDir+"/menclose.js")})(MathJax.ElementJax.mml,MathJax.OutputJax["HTML-CSS"]);']
]);

