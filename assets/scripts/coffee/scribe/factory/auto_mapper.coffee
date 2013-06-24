ReferenceProperty = require 'scribe/references/reference_property'

# 
# @author - Tim Shelburne (tim@musiconelive.com)
#
# automatically maps basic properties, basic references, and basic collections
# when they are similarly named
#
class AutoMapper

  constructor: (@entityClass)->

  canHandle: (entityClass)-> entityClass is @entityClass.name

  handle: (config)-> 
    entity = map.call @, config
    @buildEntity(config, entity) if @buildEntity?
    entity

  map = (config)->
    entity = new @entityClass(config.id)
    for prop, value of config
      if hasProperty entity, prop
        if isReferenceProperty value
          entity[prop] = createReference value
        else if isReferenceCollectionProperty value
          createReferenceCollection entity, prop, value
        else
          entity[prop] = value
    entity

  hasProperty = (entity, prop)-> prop of entity and not (entity[prop] instanceof Function)

  isReferenceProperty = (value)-> value instanceof Object and 'class' of value and 'id' of value and not (value.id instanceof Array)

  isReferenceCollectionProperty = (value)-> value instanceof Object and 'class' of value and ('ids' of value or ('id' of value and value.id instanceof Array))

  createReference = (value)-> new ReferenceProperty(value.class, value.id)

  createReferenceCollection = (entity, prop, value)->
    capitalProp = toCapitalCase prop
    refClass = value.class
    refIds = if 'id' of value then value.id else value.ids
    if entity["addTo#{capitalProp}"]?
      for refId in refIds
        reference = createReference({ class: refClass, id: refId })
        entity["addTo#{capitalProp}"](reference)
    else
      entity[prop] = (createReference({ class: refClass, id: refId }) for refId in refIds)

  toCapitalCase = (string)-> "#{string.charAt(0).toUpperCase()}#{string.slice(1)}"

return AutoMapper