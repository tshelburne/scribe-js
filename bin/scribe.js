(function(){var f=window.modules||[],d=null;f.scribe__datastore=function(){if(null===d){var b,f,h;b=require("scribe/repositories/entity_container");f=require("scribe/factory/entity_factory");h=require("scribe/factory/reference_builder");var a=function(a,c){this.entityFactory=a;this.entityContainer=c};a.create=function(a,c){var e;null==c&&(c=[]);e=new b;return new this(new f(new h(e),a,c),e)};a.prototype.buildEntity=function(a,c){return this.entityContainer.add(this.entityFactory.build(a,c))};a.prototype.buildEntities=
function(a,c){var e,j,d,b;b=[];j=0;for(d=c.length;j<d;j++)e=c[j],b.push(this.buildEntity(a,e));return b};a.prototype.getRepository=function(a){return this.entityContainer.getRepository(a)};a.prototype.find=function(a,c){return this.entityContainer.find(a,c)};d=a}return d};window.modules=f})();
(function(){var f=window.modules||[],d=null;f.scribe__factory__auto_mapper=function(){if(null===d){var b=function(c,a){this.entityClass=c;this.referenceBuilder=null!=a?a:null},f,h,a,g;b.prototype.canHandle=function(a){return a===this.entityClass.name};b.prototype.handle=function(a){var e;e=g.call(this,a);"function"===typeof this.buildEntity&&this.buildEntity(a,e);this.referenceBuilder.hydrateReferencesFor(e);return e};g=function(c){var e,g,d,b;e=new this.entityClass(c.id);for(g in c)b=c[g],f(e,g)&&
(a(b)?this.referenceBuilder.createReference(e,g,b["class"],b.id):h(b)?(d="id"in b?b.id:b.ids,this.referenceBuilder.createReferenceCollection(e,g,b["class"],d)):e[g]=b);return e};f=function(a,e){return e in a&&!(a[e]instanceof Function)};a=function(a){return a instanceof Object&&"class"in a&&"id"in a&&!(a.id instanceof Array)};h=function(a){return a instanceof Object&&"class"in a&&("ids"in a||"id"in a&&a.id instanceof Array)};d=b}return d};window.modules=f})();
(function(){var f=window.modules||[],d=null;f.scribe__factory__entity_factory=function(){if(null===d){var b;b=require("scribe/factory/auto_mapper");var f=function(a,g,c){var e,d;this.referenceBuilder=a;null==c&&(c=[]);e=0;for(d=g.length;e<d;e++)a=g[e],h(a)&&(a.referenceBuilder=this.referenceBuilder);this.mappers=g;a=0;for(e=c.length;a<e;a++)g=c[a],this.mappers.push(new b(g,this.referenceBuilder))},h;f.prototype.build=function(a,g){var c,e,b,d;d=this.mappers;e=0;for(b=d.length;e<b;e++)if(c=d[e],c.canHandle(a))return c.handle(g);
return null};h=function(a){return a instanceof b&&null==a.referenceBuilder};d=f}return d};window.modules=f})();
(function(){var f=window.modules||[],d=null;f.scribe__factory__reference_builder=function(){if(null===d){var b=function(a){this.entityContainer=a;this.pendingReferences=[]},f,h,a,g,c,e,j,k,n,p;b.prototype.createReference=function(e,b,g,d){var f;f=c.call(this,g,d);return null!=f?e[b]=f:a.call(this,e,b,g,d)};b.prototype.createReferenceCollection=function(e,b,g,d){var f,j,l,k,m;m=[];l=0;for(k=d.length;l<k;l++)f=d[l],j=c.call(this,g,f),null!=j?m.push(h(e,b,j)):m.push(a.call(this,e,b,g,f,!0));return m};
b.prototype.hydrateReferencesFor=function(a){var c,e,b,d,f;c=g.call(this,a);console.log(c.length);f=[];b=0;for(d=c.length;b<d;b++)e=c[b],n(e,a),f.push(k.call(this,e));return f};c=function(a,c){var e;return null!=(e=this.entityContainer.getRepository(a))?e.find(c):void 0};a=function(a,c,e,b,d){null==d&&(d=!1);return this.pendingReferences.push(new f(a,c,e,b,d))};g=function(a){var c,e,b,d,g;d=this.pendingReferences;g=[];e=0;for(b=d.length;e<b;e++)c=d[e],j(c,a)&&g.push(c);return g};k=function(a){return this.pendingReferences.splice(this.pendingReferences.indexOf(a),
1)};j=function(a,c){return a.refClass===e(c)&&a.refId===c.id};n=function(a,c){return a.partOfCollection?h(a.entity,a.prop,c):a.entity[a.prop]=c};h=function(a,c,e){var b;b=p(c);return null!=a["addTo"+b]?a["addTo"+b](e):a[c].push(e)};p=function(a){return""+a.charAt(0).toUpperCase()+a.slice(1)};e=function(a){a=/function (.{1,})\(/.exec(a.constructor.toString());return null!=a&&1<a.length?a[1]:""};f=function(a,c,e,b,d){this.entity=a;this.prop=c;this.refClass=e;this.refId=b;this.partOfCollection=null!=
d?d:!1};d=b}return d};window.modules=f})();
(function(){var f=window.modules||[],d=null;f.scribe__repositories__entity_container=function(){if(null===d){var b;b=require("scribe/repositories/entity_repository");var f=function(){this.repositories=[]},h;f.prototype.add=function(a){var b;b=this.getRepository(a);null==b&&(b=h.call(this,a));return b.add(a)};f.prototype.find=function(a,b){var c;c=this.getRepository(a);return null!=c?c.find(b):null};f.prototype.getRepository=function(a){var b,c,e,d;d=this.repositories;c=0;for(e=d.length;c<e;c++)if(b=
d[c],b.canHandle(a))return b;return null};h=function(a){a=new b(a.constructor);this.repositories.push(a);return a};d=f}return d};window.modules=f})();
(function(){var f=window.modules||[],d=null;f.scribe__repositories__entity_repository=function(){if(null===d){var b=function(a){this.entityClass=a;this.entityClassName=f(this.entityClass);this.entityList=[]},f,h;b.prototype.canHandle=function(a){return this.entityClass===a||this.entityClassName===a||a.constructor===this.entityClass};b.prototype.add=function(a){return this.entityList.push(a)};b.prototype.remove=function(a){return this.entityList.splice(this.entityList.indexOf(a),1)};b.prototype.find=
function(a){var b,c,e,d;d=this.entityList;c=0;for(e=d.length;c<e;c++)if(b=d[c],b.id===a)return b;return null};b.prototype.findAll=function(){return this.entityList};b.prototype.findBy=function(a){var b,c,e,d,f;d=this.entityList;f=[];c=0;for(e=d.length;c<e;c++)b=d[c],h(b,a)&&f.push(b);return f};b.prototype.findOneBy=function(a){var b,c,d,f;f=this.entityList;c=0;for(d=f.length;c<d;c++)if(b=f[c],h(b,a))return b;return null};b.prototype.numEntities=function(){return this.entityList.length};h=function(a,
b){var c,d;for(c in b)if(d=b[c],a[c]!==d)return!1;return!0};f=function(a){a=/function (.{1,})\(/.exec(a.toString());return null!=a&&1<a.length?a[1]:""};d=b}return d};window.modules=f})();(function(){var f=window.modules||[];window.require=function(d){d=d.replace(/\//g,"__");-1===d.indexOf("__")&&(d="__"+d);return null===f[d]?null:f[d]()}})();

