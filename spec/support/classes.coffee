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
EntityMapper = require "scribe/factory/entity_mapper"
AutoMapper = require "scribe/factory/auto_mapper"
ReferenceProperty = require "scribe/references/reference_property"

globalize class ExtensionMapper extends AutoMapper
  constructor: ->
    super CollectionParentEntity

  buildEntity: (config, entity)->
    entity.unConfigged = "Customized"


globalize class ReferenceEntityOneMapper extends EntityMapper
  constructor: ->
    @entityClass = "ReferenceEntityOne"

  buildEntity:(config)->
    entity = new ReferenceEntityOne(config.id)
    entity.propOne = config.propOne
    entity


globalize class ReferenceEntityTwoMapper extends EntityMapper
  constructor:->
    @entityClass = "ReferenceEntityTwo"

  buildEntity:(config)->
    entity = new ReferenceEntityTwo(config.id)
    entity.propOne = config.propOne
    entity.propTwo = config.propTwo
    entity


globalize class ParentEntityMapper extends EntityMapper
  constructor:->
    @entityClass = "ParentEntity"

  buildEntity:(config)->
    entity = new ParentEntity(config.id)
    entity.propOne = config.propOne
    entity.referenceOne = new ReferenceProperty(config.referenceOne.class, config.referenceOne.id)
    entity.referenceTwo = new ReferenceProperty(config.referenceTwo.class, config.referenceTwo.id)
    entity


globalize class CollectionParentEntityMapper extends EntityMapper
  constructor:->
    @entityClass = "CollectionParentEntity"

  buildEntity:(config)->
    entity = new CollectionParentEntity(config.id)
    entity.propOne = config.propOne
    entity.referenceOne = new ReferenceProperty(config.referenceOne.class, config.referenceOne)
    entity.referenceTwo = new ReferenceProperty(config.referenceTwo.class, config.referenceTwo.id)

    for refId in config.referenceCollection.ids
      entity.referenceCollection.push(new ReferenceProperty(config.referenceCollection.class, refId))

    entity