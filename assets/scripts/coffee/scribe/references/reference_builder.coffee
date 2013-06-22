class ReferenceBuilder

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

return ReferenceBuilder