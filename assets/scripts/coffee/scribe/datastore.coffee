EntityConstructorMap = require 'scribe/repositories/entity_constructor_map'
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
    
  @create: (customMappers, automappableClasses=[], constructorMap={})->
    container = new EntityContainer()
    factory = new EntityFactory(new ReferenceBuilder(container), customMappers, automappableClasses)
    datastore = new @(factory, container)
    datastore.registerConstructor ctorName, ctor for ctorName, ctor of constructorMap
    datastore

  registerConstructor: (ctorName, ctor)-> EntityConstructorMap.link ctorName, ctor

  buildEntity: (entityClass, entityConfig)-> @entityContainer.add(@entityFactory.build(entityClass, entityConfig))

  buildEntities: (entityClass, entityConfigs)-> @buildEntity(entityClass, config) for config in entityConfigs

  getRepository: (entityClass)-> @entityContainer.getRepository(entityClass)

  find: (entityClass, id)-> @entityContainer.find(entityClass, id)

return DataStore