#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# contains all entities of a given constructor
#
class EntityRepository

  constructor: (@entityClass)->
    @entityList = []

  canHandle: (entityCheck)->
    @entityClass is entityCheck or @entityClass.name is entityCheck or entityCheck.constructor is @entityClass

  add: (entity)-> @entityList.push entity

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

  # PRIVATE

  isMatch = (entity, criteria)->
    return false for prop, value of criteria when entity[prop] isnt value
    true
    
return EntityRepository