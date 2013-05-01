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

  @default: (mappers)->
    new @(new EntityFactory(mappers))

  buildEntity: (entityType, entityConfig, buildReferences = true)->
    @getRepository(entityType).add(@entityFactory.build(entityType, entityConfig))

    @rebuildReferences() if buildReferences

  buildEntities: (entityType, entityConfigs, buildReferences = true)->
    for config in entityConfigs
      @buildEntity entityType, config, false

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
              refRefo = @getRepository(referenceProperty.entityType)
              entityReference = if refRefo? then refRefo.find(referenceProperty.entityId) else null
              if entityReference?
                referencesBuilt++
                entity[propName] = entityReference

            # handle hydrating reference collections
            collectionsBuilt = 0
            for collectionPropName in repo.metadata.referenceCollections

              collectionReferencesBuilt = 0
              for refIndex, referenceProperty of entity[collectionPropName]
                collRefRepo = @getRepository(referenceProperty.entityType)
                entityReference = if collRefRepo? then collRefRepo.find(referenceProperty.entityId) else null
                if entityReference?
                  collectionReferencesBuilt++
                  entity[collectionPropName][refIndex] = entityReference
              if collectionReferencesBuilt == entity[collectionPropName].length
                collectionsBuilt++

            # check whether all references for this entity were built
            if referencesBuilt == repo.numReferenceProperties() and collectionsBuilt == repo.numReferenceCollections()
              entity.hydrated = true

  getRepository: (entityType)->
    for repo in @repos
      if repo.canHandle entityType
        return repo

    newRepo = new EntityRepository(entityType)
    @repos.push newRepo
    return newRepo

  find: (entityType, id)->
    @getRepository(entityType).find(id)

return DataStore