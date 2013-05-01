#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class responsible for building entities of various types
#
class EntityFactory
  constructor: (@mappers)->

  build: (type, config)->
    for mapper in @mappers
      return mapper.handle(config) if mapper.canHandle(type)
    return null

return EntityFactory