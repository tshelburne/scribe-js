# 
# @author - Tim Shelburne (tim@musiconelive.com)
#
# handles storing a map of strings to constructors in order to allow running 
# Closure (or another minifier) over the application code
#
class EntityConstructorMap

	@ctors = {}

	@link: (ctorName, ctor)-> @ctors[ctorName] = ctor

	@find: (ctorName)-> @ctors[ctorName]

	@match: (ctorName, ctor)->
		return @find(ctorName) is ctor if @find(ctorName)?
		getCtorName(ctor) is ctorName

	getCtorName = (entityClass)->
		funcNameRegex = /function (.{1,})\(/;
		results = (funcNameRegex).exec(entityClass.toString());
		if (results? and results.length > 1) then results[1] else ""

return EntityConstructorMap