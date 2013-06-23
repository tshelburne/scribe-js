EntityMapper = require 'scribe/factory/entity_mapper'

# 
# @author - Tim Shelburne (tim@musiconelive.com)
#
# automatically maps basic properties, basic references, and basic collections
# when they are similarly named
#
class AutoMapper extends EntityMapper

  constructor: (@type, @entityClass)->

  handle: (config)->
    entity = @map(config)
    entity.entityType = @type
    entity

  map: (config)->
    entity = new @entityClass(config.id)
    for prop, value of config
      if prop in entity and not entity[prop] instanceof Function
        if isReferenceProperty value
          entity[prop] = createReference value
        else if isReferenceCollectionProperty value
          entity[prop] = createReferenceCollection value
        else
          entity[prop] = value

    @buildEntity(config, entity) if @buildEntity?

  isReferenceProperty = (propConfig)->
    'type' in propConfig and 'id' in propConfig and not propConfig.id instanceof Array

  isReferenceCollectionProperty = (propConfig)->
    'type' in propConfig and ('ids' in propConfig or ('id' in propConfig and propConfig.id instanceof Array))

  createReference = (refConfig)->
    new ReferenceProperty(refConfig.type, refConfig.id)

  createReferenceCollection = (refConfig)->
    (createReference({ type: refConfig.type, id: refId }) for refId in refConfig.ids)

return AutoMapper