EntityContainer = require "scribe/repositories/entity_container"
EntityFactory = require "scribe/factory/entity_factory"
ReferenceBuilder = require 'scribe/factory/reference_builder'

#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a container for all entities within the domain
#
class DataStore

  constructor: (@entityFactory, @entityContainer)->
    
  @create: (customMappers, automappableClasses=[])->
    container = new EntityContainer()
    factory = new EntityFactory(new ReferenceBuilder(container), customMappers, automappableClasses)
    new @(factory, container)

  buildEntity: (entityClass, entityConfig)-> @entityContainer.add(@entityFactory.build(entityClass, entityConfig))

  buildEntities: (entityClass, entityConfigs)-> @buildEntity(entityClass, config) for config in entityConfigs

  getRepository: (entityClass)-> @entityContainer.getRepository(entityClass)

  find: (entityClass, id)-> @entityContainer.find(entityClass, id)

return DataStore