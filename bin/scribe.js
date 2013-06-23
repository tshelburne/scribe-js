(function(){var b=window.modules||[],a=null;b.scribe__datastore=function(){if(null===a){var b,d;d=require("scribe/repositories/entity_repository");b=require("scribe/factory/entity_factory");var f=function(e){this.entityFactory=e;this.repos=[]};f["default"]=function(e){return new this(new b(e))};f.prototype.buildEntity=function(e,g,c){null==c&&(c=!0);this.getRepository(e).add(this.entityFactory.build(e,g));if(c)return this.rebuildReferences()};f.prototype.buildEntities=function(e,g,c){var h,d,a;null==
c&&(c=!0);d=0;for(a=g.length;d<a;d++)h=g[d],this.buildEntity(e,h,!1);if(c)return this.rebuildReferences()};f.prototype.rebuildReferences=function(){var e,g,c,d,a,b,f,t,u,v,n,r,j,k,m,w,l;w=this.repos;l=[];k=0;for(m=w.length;k<m;k++)j=w[k],0<j.numEntities()&&j.hasReferences()?(e=j.findAll(),l.push(function(){var l,q,z,k,s,w,m;m=[];l=0;for(z=e.length;l<z;l++)if(b=e[l],b.hydrated)m.push(void 0);else{r=0;s=j.metadata.references;q=0;for(k=s.length;q<k;q++)t=s[q],n=b[t],v=this.getRepository(n.entityType),
f=null!=v?v.find(n.entityId):null,null!=f&&(r++,b[t]=f);a=0;s=j.metadata.referenceCollections;q=0;for(k=s.length;q<k;q++){c=s[q];d=0;w=b[c];for(u in w)n=w[u],g=this.getRepository(n.entityType),f=null!=g?g.find(n.entityId):null,null!=f&&(d++,b[c][u]=f);d===b[c].length&&a++}r===j.numReferenceProperties()&&a===j.numReferenceCollections()?m.push(b.hydrated=!0):m.push(void 0)}return m}.call(this))):l.push(void 0);return l};f.prototype.getRepository=function(e){var g,c,a,b;b=this.repos;c=0;for(a=b.length;c<
a;c++)if(g=b[c],g.canHandle(e))return g;e=new d(e);this.repos.push(e);return e};f.prototype.find=function(e,a){return this.getRepository(e).find(a)};a=f}return a};window.modules=b})();(function(){var b=window.modules||[],a=null;b.scribe__factory__entity_factory=function(){if(null===a){var b=function(a){this.mappers=a};b.prototype.build=function(a,b){var e,g,c,h;h=this.mappers;g=0;for(c=h.length;g<c;g++)if(e=h[g],e.canHandle(a))return e.handle(b);return null};a=b}return a};window.modules=b})();
(function(){var b=window.modules||[],a=null;b.scribe__factory__entity_mapper=function(){if(null===a){var b=function(){this.type=null};b.prototype.canHandle=function(a){return a===this.type};b.prototype.handle=function(a){a=this.buildEntity(a);a.entityType=this.type;return a};b.prototype.buildEntity=function(){return alert("You must override the buildEntity() function to create a data mapper.")};a=b}return a};window.modules=b})();
(function(){var b=window.modules||[],a=null;b.scribe__references__reference_builder=function(){if(null===a){var b=function(){};b.prototype.rebuildReferences=function(){var a,b,e,g,c,h,p,t,x,y,u,v,n,r,j,k,m;k=this.repos;m=[];r=0;for(j=k.length;r<j;r++)n=k[r],0<n.numEntities()&&n.hasReferences()?(a=n.findAll(),m.push(function(){var k,l,m,q,j,r,s;s=[];k=0;for(m=a.length;k<m;k++)if(h=a[k],h.hydrated)s.push(void 0);else{v=0;j=n.metadata.references;l=0;for(q=j.length;l<q;l++)t=j[l],u=h[t],y=this.getRepository(u.entityType),
p=null!=y?y.find(u.entityId):null,null!=p&&(v++,h[t]=p);c=0;j=n.metadata.referenceCollections;l=0;for(q=j.length;l<q;l++){e=j[l];g=0;r=h[e];for(x in r)u=r[x],b=this.getRepository(u.entityType),p=null!=b?b.find(u.entityId):null,null!=p&&(g++,h[e][x]=p);g===h[e].length&&c++}v===n.numReferenceProperties()&&c===n.numReferenceCollections()?s.push(h.hydrated=!0):s.push(void 0)}return s}.call(this))):m.push(void 0);return m};a=b}return a};window.modules=b})();
(function(){var b=window.modules||[],a=null;b.scribe__references__reference_property=function(){null===a&&(a=function(a,b){this.entityType=a;this.entityId=b});return a};window.modules=b})();
(function(){var b=window.modules||[],a=null;b.scribe__repositories__entity_metadata=function(){if(null===a){var b;b=require("scribe/references/reference_property");var d=function(){this.isBuilt=!1;this.type="";this.properties=[];this.references=[];this.referenceCollections=[]},f;d.prototype.buildFromInstance=function(a){var b,c;this.type=a.entityType;for(b in a)c=a[b],c instanceof Array&&0<c.length&&f(c[0])?this.referenceCollections.push(b):f(c)?this.references.push(b):this.properties.push(b);return this.isBuilt=
!0};d.prototype.hasReferences=function(){return this.isBuilt?0<this.references.length||0<this.referenceCollections.length:null};f=function(a){return a instanceof b};a=d}return a};window.modules=b})();
(function(){var b=window.modules||[],a=null;b.scribe__repositories__entity_repository=function(){if(null===a){var b;b=require("scribe/repositories/entity_metadata");var d=function(a){this.type=a;this.entityList=[];this.metadata=new b},f;d.prototype.canHandle=function(a){return this.type===a};d.prototype.add=function(a){this.metadata.isBuilt||this.metadata.buildFromInstance(a);return this.entityList.push(a)};d.prototype.remove=function(a){return this.entityList.splice(this.entityList.indexOf(a),1)};
d.prototype.find=function(a){var b,c,h,d;d=this.entityList;c=0;for(h=d.length;c<h;c++)if(b=d[c],b.id===a)return b;return null};d.prototype.findAll=function(){return this.entityList};d.prototype.findBy=function(a){var b,c,d,p,t;c=[];t=this.entityList;d=0;for(p=t.length;d<p;d++)b=t[d],f(b,a)&&c.push(b);return c};d.prototype.findOneBy=function(a){var b,c,d,p;p=this.entityList;c=0;for(d=p.length;c<d;c++)if(b=p[c],f(b,a))return b;return null};d.prototype.numEntities=function(){return this.entityList.length};
d.prototype.hasReferences=function(){return this.metadata.hasReferences()};d.prototype.numReferenceProperties=function(){return this.metadata.isBuilt?this.metadata.references.length:null};d.prototype.numReferenceCollections=function(){return this.metadata.isBuilt?this.metadata.referenceCollections.length:null};f=function(a,b){var c,d;c=!0;for(d in b)c=c?a[d]===b[d]:!1;return c};a=d}return a};window.modules=b})();
(function(){var b=window.modules||[];window.require=function(a){a=a.replace(/\//g,"__");-1===a.indexOf("__")&&(a="__"+a);return null===b[a]?null:b[a]()}})();

