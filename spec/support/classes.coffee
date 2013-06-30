#
# ENTITIES
#
globalize class ReferenceEntityOne
  constructor:(@id)->
    @propOne = null
    @hydrated = true


globalize class ReferenceEntityTwo
  constructor:(@id)->
    @propOne = null
    @propTwo = null
    @hydrated = true


globalize class ParentEntity
  constructor:(@id)->
    @propOne = null
    @referenceOne = null
    @referenceTwo = null
    @hydrated = false


globalize class CollectionParentEntity
  constructor:(@id)->
    @unConfigged = null
    @propOne = null
    @referenceOne = null
    @referenceTwo = null
    @referenceCollection = []
    @hydrated = false


#
# MAPPERS
#
AutoMapper = require "scribe/factory/auto_mapper"

globalize class ExtensionMapper extends AutoMapper
  constructor: (referenceBuilder)->
    super CollectionParentEntity, referenceBuilder

  buildEntity: (config, entity)->
    entity.unConfigged = "Customized"