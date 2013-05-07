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

  canHandle: (type)->
    @type == type

  hasReferences: ->
    @metadata.hasReferences()

  add: (entity)->
    unless @metadata.isBuilt
      @metadata.buildFromInstance(entity)
    @entityList.push entity

  remove: (entity)->
    @entityList.splice @entityList.indexOf(entity), 1

  find: (id)->
    for entity in @entityList
      return entity if entity.id == id
    null

  findAll: ->
    @entityList

  findBy: (criteria)->
    results = []
    for entity in @entityList
      if @isMatch(entity, criteria)
        results.push entity
    results

  findOneBy: (criteria)->
    for entity in @entityList
      if @isMatch(entity, criteria)
        return entity
    null

  isMatch: (entity, criteria)->
    match = true
    for prop, value of criteria
      match = if match then entity[prop] == criteria[prop] else false
    match

  numEntities: ->
    @entityList.length

  numReferenceProperties: ->
    @metadata.references.length

  numReferenceCollections: ->
    @metadata.referenceCollections.length

return EntityRepository