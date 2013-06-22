EntityMetadata = require 'scribe/repositories/entity_metadata'

describe "EntityMetadata", ->
	metadata = null

	addBasicEntity = ->
		entity = new ReferenceEntityOneMapper().buildEntity({ id: "1", propOne: "prop 1" })
		entity.entityType = "referenceEntityOne"
		metadata.buildFromInstance entity

	addParentEntity = ->
		entity = new ParentEntityMapper().buildEntity({ id: "2", propOne: "prop 2", referenceOne: "1", referenceTwo: "2" })
		entity.entityType = "parentEntity"
		metadata.buildFromInstance entity

	addCollectionEntity = ->
		entity = new CollectionParentEntityMapper().buildEntity({ id: "3", propOne: "prop 3", referenceOne: "1", referenceTwo: "2", referenceCollection: [ '1', '2', '3' ] })
		entity.entityType = "collectionParentEntity"
		metadata.buildFromInstance entity

	beforeEach -> 
		metadata = new EntityMetadata()

	describe '#buildFromInstance', ->

		it "will set the type to the instance's entityType", ->
			addBasicEntity()
			expect(metadata.type).toEqual "referenceEntityOne"

		it "will set the metadata to built", ->
			addBasicEntity()
			expect(metadata.isBuilt).toBeTruthy()

		it "will add basic properties into the properties list", ->
			addBasicEntity()
			expect(metadata.properties).toEqual [ "id", "hydrated", "propOne", "entityType" ]

		it "will add reference properties into the references list", ->
			addParentEntity()
			expect(metadata.references).toEqual [ "referenceOne", "referenceTwo" ]

		it "will add collection reference properties into the referenceCollections list", ->
			addCollectionEntity()
			expect(metadata.referenceCollections).toEqual [ "referenceCollection" ]

	describe "#hasReferences", ->

		it "will return true if there are reference properties on this type of entity", ->
			addParentEntity()
			expect(metadata.hasReferences()).toBeTruthy()

		it "will return true if there are reference collection properties on this type of entity", ->
			addCollectionEntity()
			expect(metadata.hasReferences()).toBeTruthy()

		it "will return false if there are no reference properties on this type of entity", ->
			addBasicEntity()
			expect(metadata.hasReferences()).toBeFalsy()

		it "will return null if it has not yet been built", ->
			expect(metadata.hasReferences()).toBeNull()