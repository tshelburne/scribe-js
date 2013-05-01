#
# ENTITIES
#
class ReferenceEntityOne
  constructor:(@id)->
    @propOne
    @hydrated = true


class ReferenceEntityTwo
  constructor:(@id)->
    @propOne
    @propTwo
    @hydrated = true


class ParentEntity
  constructor:(@id)->
    @propOne
    @referenceOne
    @referenceTwo
    @hydrated = false


class CollectionParentEntity
  constructor:(@id)->
    @propOne
    @referenceOne
    @referenceTwo
    @referenceCollection = []
    @hydrated = false


#
# MAPPERS
#
EntityMapper = require "scribe/factory/entity_mapper"
ReferenceProperty = require "scribe/factory/reference_property"

globalize class ReferenceEntityOneMapper extends EntityMapper
  constructor: ->
    @type = "referenceOne"

  buildEntity:(config)->
    entity = new ReferenceEntityOne(config.id)
    entity.propOne = config.propOne
    entity


globalize class ReferenceEntityTwoMapper extends EntityMapper
  constructor:(type)->
    @type = "referenceTwo"

  buildEntity:(config)->
    entity = new ReferenceEntityTwo(config.id)
    entity.propOne = config.propOne
    entity.propTwo = config.propTwo
    entity


globalize class ParentEntityMapper extends EntityMapper
  constructor:(type)->
    @type = "parent"

  buildEntity:(config)->
    entity = new ParentEntity(config.id)
    entity.propOne = config.propOne
    entity.referenceOne = new ReferenceProperty("referenceOne", config.referenceOne)
    entity.referenceTwo = new ReferenceProperty("referenceTwo", config.referenceTwo)
    entity


globalize class CollectionParentEntityMapper extends EntityMapper
  constructor:(type)->
    @type = "collectionParent"

  buildEntity:(config)->
    entity = new CollectionParentEntity(config.id)
    entity.propOne = config.propOne
    entity.referenceOne = new ReferenceProperty("referenceOne", config.referenceOne)
    entity.referenceTwo = new ReferenceProperty("referenceTwo", config.referenceTwo)

    for refId in config.referenceCollection
      entity.referenceCollection.push(new ReferenceProperty("referenceOne", refId))

    entity