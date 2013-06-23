EntityMetadata = require 'scribe/repositories/entity_metadata'

describe "EntityMetadata", ->
	metadata = null

	addBasicEntity = ->
		entity = new ReferenceEntityOneMapper().buildEntity(mocks.datastoreConfig.ReferenceEntityOne[0])
		metadata.buildFromInstance entity

	addParentEntity = ->
		entity = new ParentEntityMapper().buildEntity(mocks.datastoreConfig.ParentEntity[0])
		metadata.buildFromInstance entity

	addCollectionEntity = ->
		entity = new CollectionParentEntityMapper().buildEntity(mocks.datastoreConfig.CollectionParentEntity[0])
		metadata.buildFromInstance entity

	beforeEach -> 
		metadata = new EntityMetadata()

	describe '#buildFromInstance', ->

		it "will set the klass to the instance's constructor", ->
			addBasicEntity()
			expect(metadata.klass).toEqual ReferenceEntityOne

		it "will add basic properties into the properties list", ->
			addBasicEntity()
			expect(metadata.properties).toEqual [ "id", "hydrated", "propOne" ]

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