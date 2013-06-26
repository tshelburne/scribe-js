EntityMetadata = require "scribe/repositories/entity_metadata"

#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# contains all entities of a given constructor
#
class EntityRepository

  constructor: ->
    @entityList = []
    @metadata = new EntityMetadata()

  canHandle: (entityCheck)-> 
    return false unless metadataHasBeenBuilt.call @
    @metadata.klass is entityCheck or @metadata.klass.name is entityCheck or entityCheck.constructor is @metadata.klass

  add: (entity)->
    @metadata.buildFromInstance(entity) unless metadataHasBeenBuilt.call @
    @entityList.push entity

  remove: (entity)-> @entityList.splice @entityList.indexOf(entity), 1

  find: (id)->
    return entity for entity in @entityList when entity.id is id
    null

  findAll: -> @entityList

  findBy: (criteria)-> (entity for entity in @entityList when isMatch(entity, criteria))

  findOneBy: (criteria)->
    return entity for entity in @entityList when isMatch(entity, criteria)
    null

  numEntities: -> @entityList.length

  hasReferences: -> @metadata.hasReferences()

  numReferenceProperties: -> if metadataHasBeenBuilt.call @ then @metadata.references.length else null

  numReferenceCollections: -> if metadataHasBeenBuilt.call @ then @metadata.referenceCollections.length else null

  isMatch = (entity, criteria)->
    return false for prop, value of criteria when entity[prop] isnt value
    true

  metadataHasBeenBuilt = ->
    @metadata.klass isnt null

return EntityRepository