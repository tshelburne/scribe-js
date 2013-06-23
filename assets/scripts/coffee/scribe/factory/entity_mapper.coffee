#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# the base data mapper
#
class EntityMapper
  constructor: ->
    @entityClass = null

  canHandle: (entityClass)->
    entityClass is @entityClass

  handle: (config)->
    @buildEntity(config)
    
  buildEntity: (config)->
    console.log "You must override the buildEntity() function to create a data mapper."

return EntityMapper