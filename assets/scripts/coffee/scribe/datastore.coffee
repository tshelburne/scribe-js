EntityRepository = require "scribe/repositories/entity_repository"
EntityFactory = require "scribe/factory/entity_factory"

#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a container for all entities within the domain
#
class DataStore
  constructor: (@entityFactory)->
    @repos = []

  @create: (mappers)->
    new @(new EntityFactory(mappers))

  buildEntity: (entityClass, entityConfig, buildReferences = true)->
    @getRepository(entityClass).add(@entityFactory.build(entityClass, entityConfig))

    @rebuildReferences() if buildReferences

  buildEntities: (entityClass, entityConfigs, buildReferences = true)->
    for config in entityConfigs
      @buildEntity entityClass, config, false

    @rebuildReferences() if buildReferences

  rebuildReferences: ->
    for repo in @repos # loop through all repositories
      if (repo.numEntities() > 0 and repo.hasReferences()) # check that entities in this repository have reference properties
        allEntities = repo.findAll()
        for entity in allEntities # loop through all entities in this repository
          if not entity.hydrated # if the entity isn't hydrated, build references and collections
            # handle hydrating the individual references
            referencesBuilt = 0
            for propName in repo.metadata.references
              referenceProperty = entity[propName]
              refRefo = @getRepository(referenceProperty.entityClass)
              entityReference = if refRefo? then refRefo.find(referenceProperty.entityId) else null
              if entityReference?
                referencesBuilt++
                entity[propName] = entityReference

            # handle hydrating reference collections
            collectionsBuilt = 0
            for collectionPropName in repo.metadata.referenceCollections

              collectionReferencesBuilt = 0
              for refIndex, referenceProperty of entity[collectionPropName]
                collRefRepo = @getRepository(referenceProperty.entityClass)
                entityReference = if collRefRepo? then collRefRepo.find(referenceProperty.entityId) else null
                if entityReference?
                  collectionReferencesBuilt++
                  entity[collectionPropName][refIndex] = entityReference
              if collectionReferencesBuilt is entity[collectionPropName].length
                collectionsBuilt++

            # check whether all references for this entity were built
            if referencesBuilt is repo.numReferenceProperties() and collectionsBuilt is repo.numReferenceCollections()
              entity.hydrated = true

  getRepository: (entityClass)->
    for repo in @repos
      if repo.canHandle entityClass
        return repo

    newRepo = new EntityRepository(entityClass)
    @repos.push newRepo
    return newRepo

  find: (entityClass, id)->
    @getRepository(entityClass).find(id)

return DataStore