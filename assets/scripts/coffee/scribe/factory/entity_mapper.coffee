#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# the base data mapper
#
class EntityMapper
  constructor: ()->
    @type = null

  canHandle: (type)->
    type is @type

  handle: (config)->
    entity = @buildEntity(config)
    entity.entityType = @type
    entity

  buildEntity: (config)->
    alert "You must override the buildEntity() function to create a data mapper."

return EntityMapper