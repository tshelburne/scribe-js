ReferenceProperty = require 'scribe/references/reference_property'

#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class to contain metadata about a given entity
#
class EntityMetadata

  constructor: ->
    @isBuilt = false
    @type = ""
    @properties = []
    @references = []
    @referenceCollections = []

  buildFromInstance: (instance)->
    @type = instance.entityType

    for prop, value of instance
      if value instanceof Array and value.length > 0 and isReference(value[0])
        @referenceCollections.push(prop)
      else if isReference(value)
        @references.push(prop)
      else
        @properties.push prop

    @isBuilt = true

  hasReferences: -> if @isBuilt then @references.length > 0 or @referenceCollections.length > 0 else null

  isReference = (value)-> value instanceof ReferenceProperty

return EntityMetadata