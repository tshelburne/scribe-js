#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class responsible for building entities of various types
#
class EntityFactory
  constructor: (@mappers)->

  build: (entityClass, config)->
    for mapper in @mappers
      return mapper.handle(config) if mapper.canHandle(entityClass)
    return null

return EntityFactory