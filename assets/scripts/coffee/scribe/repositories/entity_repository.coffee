EntityMetadata = require "scribe/repositories/entity_metadata"

#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# contains all entities of a given type
#
class EntityRepository

  constructor: (@type)->
    @entityList = []
    @metadata = new EntityMetadata()

  canHandle: (type)-> @type is type

  add: (entity)->
    @metadata.buildFromInstance(entity) unless @metadata.isBuilt
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

  numReferenceProperties: -> if @metadata.isBuilt then @metadata.references.length else null

  numReferenceCollections: -> if @metadata.isBuilt then @metadata.referenceCollections.length else null

  isMatch = (entity, criteria)->
    # return false unless entity[prop] is value for prop, value of criteria
    # true
    match = true
    for prop, value of criteria
      match = if match then entity[prop] is criteria[prop] else false
    match

return EntityRepository