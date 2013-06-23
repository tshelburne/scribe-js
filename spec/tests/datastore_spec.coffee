DataStore = require "scribe/datastore"
EntityFactory = require "scribe/factory/entity_factory"
EntityRepository = require "scribe/repositories/entity_repository"

describe "DataStore", ->
	datastore = null
	entityFactory = new EntityFactory([
		new ReferenceEntityOneMapper(),
		new ReferenceEntityTwoMapper(),
		new ParentEntityMapper(),
		new CollectionParentEntityMapper()
	])

	beforeEach ->
		datastore = new DataStore(entityFactory)

	describe "::create", ->

		it "will create a datastore using the packaged classes in Scribe", ->
			datastore = DataStore.create([ new ReferenceEntityOneMapper(), new ReferenceEntityTwoMapper() ])
			expect(datastore.constructor).toEqual DataStore

	describe "#buildEntity", ->

		it "will build an entity", ->
			datastore.buildEntity("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne[0], false)
			entity = datastore.find "ReferenceEntityOne", "1"
			expect(entity).not.toBeNull()
			expect(entity instanceof ReferenceEntityOne).toBeTruthy()

		it "will create a repository if one doesn't exist", ->
			datastore.buildEntity("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne[0], false)
			expect(datastore.getRepository "ReferenceEntityOne").not.toBeNull()

		it "will add the entity to the repository", ->
			datastore.buildEntity("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne[0], false)
			entity = datastore.getRepository("ReferenceEntityOne").find("1")
			expect(entity).not.toBeNull()
			expect(entity.propOne).toEqual "valueOne"

		it "will build entity references when buildReferences is true", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne, false)
			datastore.buildEntities("ReferenceEntityTwo", mocks.datastoreConfig.ReferenceEntityTwo, false)
			datastore.buildEntities("ParentEntity", mocks.datastoreConfig.ParentEntity)
			entity = datastore.find("ParentEntity", "4")
			expect(entity.ReferenceEntityOne).not.toBeNull()
			expect(entity.referenceOne.propOne).toEqual "valueOne"
			expect(entity.referenceTwo.propTwo).toEqual "valueTwo"

		it "will build entity reference collections when buildReferences is true", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne, false)
			datastore.buildEntities("ReferenceEntityTwo", mocks.datastoreConfig.ReferenceEntityTwo, false)
			datastore.buildEntities("CollectionParentEntity", mocks.datastoreConfig.CollectionParentEntity)
			entity = datastore.find("CollectionParentEntity", "5")
			expect(entity.referenceCollection).not.toEqual []
			for ref in entity.referenceCollection
				expect(ref).toBeDefined()
				expect(ref.propOne).toBeDefined()

	describe "#buildEntities", ->

		it "will build multiple entities", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne, false)
			repo = datastore.getRepository "ReferenceEntityOne"
			expect(repo).not.toBeNull()
			expect(repo.entityList.length).toEqual 2

	describe "#getRepository", ->

		it "will return an entity repository", ->
			expect(datastore.getRepository "ReferenceEntityOne" instanceof EntityRepository).toBeTruthy()

		it "will return the requested repo when it exists", ->
			datastore.buildEntity('ReferenceEntityOne', mocks.datastoreConfig.ReferenceEntityOne[0], false)
			expect(datastore.getRepository "ReferenceEntityOne").toEqual datastore.repos[0]

		it "will create a repository when one doesn't exist", ->
			expect(datastore.repos).toEqual [ ]
			repo = datastore.getRepository "ReferenceEntityOne"
			expect(datastore.repos).toEqual [ repo ]

	describe "#find", ->

		it "will return an entity", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne, false)
			entity = datastore.find("ReferenceEntityOne", "1")
			expect(entity).not.toEqual null
			expect(entity.propOne).toEqual "valueOne"

		it "will return null when that entity doesn't exist", ->
			expect(datastore.find('ReferenceEntityOne', 'bad-id')).toBeNull()