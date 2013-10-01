EntityConstructorMap = require 'scribe/repositories/entity_constructor_map'

# 
# @author - Tim Shelburne (tim@musiconelive.com)
#
# automatically maps basic properties, basic references, and basic collections
# when they are similarly named
#
class AutoMapper

  constructor: (@entityClass, @referenceBuilder=null)->

  canHandle: (entityClass)-> EntityConstructorMap.match(entityClass, @entityClass)

  handle: (config)-> 
    entity = map.call @, config
    @buildEntity?(config, entity)
    @referenceBuilder.hydrateReferencesFor entity
    entity

  # PRIVATE

  map = (config)->
    entity = new @entityClass(config.id)
    for prop, value of config
      if hasProperty entity, prop
        if isReferenceProperty value
          @referenceBuilder.createReference(entity, prop, value.class, value.id)
        else if isReferenceCollectionProperty value
          refIds = if 'id' of value then value.id else value.ids
          @referenceBuilder.createReferenceCollection(entity, prop, value.class, refIds)
        else
          entity[prop] = value
    entity

  hasProperty = (entity, prop)-> prop of entity and not (entity[prop] instanceof Function)

  isReferenceProperty = (value)-> value instanceof Object and 'class' of value and 'id' of value and not (value.id instanceof Array)

  isReferenceCollectionProperty = (value)-> value instanceof Object and 'class' of value and ('ids' of value or ('id' of value and value.id instanceof Array))

return AutoMapper