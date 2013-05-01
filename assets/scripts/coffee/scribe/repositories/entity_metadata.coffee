#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class to contain metadata about a given entity
#
class EntityMetadata

  constructor: (entity)->
    @type = entity.entityType
    @properties = []
    @references = []
    @referenceCollections = []

    for prop, value of entity
      if value instanceof Array and value.length > 0 and @isReference(value[0])
        @referenceCollections.push(prop)
      else if @isReference(value)
        @references.push(prop)
      else
        @properties.push prop

  isReference: (value)->
    value.hasOwnProperty("entityType") and value.hasOwnProperty("entityId")

  hasReferences: ->
    @references.length > 0 or @referenceCollections.length > 0

return EntityMetadata