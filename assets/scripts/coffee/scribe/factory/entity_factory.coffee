AutoMapper = require 'scribe/factory/auto_mapper'

#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class responsible for building entities of various types
#
class EntityFactory
	constructor: (@referenceBuilder, customMappers, automappableClasses=[])->
		mapper.referenceBuilder = @referenceBuilder for mapper in customMappers when shouldHaveReferenceBuilder mapper
		@mappers = customMappers
		@mappers.push new AutoMapper(entityClass, @referenceBuilder) for entityClass in automappableClasses

	build: (entityClass, config)->
		return mapper.handle config for mapper in @mappers when mapper.canHandle entityClass
		null

	# PRIVATE

	shouldHaveReferenceBuilder = (mapper)->
		mapper instanceof AutoMapper and not mapper.referenceBuilder?

return EntityFactory