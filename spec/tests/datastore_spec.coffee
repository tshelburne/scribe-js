DataStore = require "scribe/datastore"
EntityFactory    = require "scribe/factory/entity_factory"
ReferenceBuilder = require 'scribe/factory/reference_builder'
EntityContainer  = require 'scribe/repositories/entity_container'
EntityRepository = require "scribe/repositories/entity_repository"

describe "DataStore", ->
	datastore = container = referenceBuilder = factory = null

	beforeEach ->
		container = new EntityContainer()
		referenceBuilder = new ReferenceBuilder(container)
		factory = new EntityFactory(referenceBuilder, [ ], [ ReferenceEntityOne, ReferenceEntityTwo, ParentEntity, CollectionParentEntity ])
		datastore = new DataStore(factory, container)

	describe "::create", ->

		it "will create a datastore using the packaged classes in Scribe", ->
			datastore = DataStore.create([ ], [ ReferenceEntityOne, ReferenceEntityTwo ])
			expect(datastore.constructor).toEqual DataStore

	describe "#buildEntity", ->

		it "will build an entity", ->
			datastore.buildEntity("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne[0])
			entity = datastore.find "ReferenceEntityOne", "1"
			expect(entity).not.toBeNull()
			expect(entity.constructor).toEqual ReferenceEntityOne

		it "will create a repository if one doesn't exist", ->
			datastore.buildEntity("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne[0])
			expect(datastore.getRepository "ReferenceEntityOne").not.toBeNull()

		it "will add the entity to the repository", ->
			datastore.buildEntity("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne[0])
			entity = datastore.getRepository("ReferenceEntityOne").find("1")
			expect(entity).not.toBeNull()
			expect(entity.propOne).toEqual "valueOne"

		it "will build entity references when buildReferences is true", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne)
			datastore.buildEntities("ReferenceEntityTwo", mocks.datastoreConfig.ReferenceEntityTwo)
			datastore.buildEntities("ParentEntity", mocks.datastoreConfig.ParentEntity)
			entity = datastore.find("ParentEntity", "4")
			expect(entity.ReferenceEntityOne).not.toBeNull()
			expect(entity.referenceOne.propOne).toEqual "valueOne"
			expect(entity.referenceTwo.propTwo).toEqual "valueTwo"

		it "will build entity reference collections when buildReferences is true", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne)
			datastore.buildEntities("ReferenceEntityTwo", mocks.datastoreConfig.ReferenceEntityTwo)
			datastore.buildEntities("CollectionParentEntity", mocks.datastoreConfig.CollectionParentEntity)
			entity = datastore.find("CollectionParentEntity", "5")
			expect(entity.referenceCollection).not.toEqual []
			for ref in entity.referenceCollection
				expect(ref).toBeDefined()
				expect(ref.propOne).toBeDefined()

	describe "#buildEntities", ->

		it "will build multiple entities", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne)
			repo = datastore.getRepository "ReferenceEntityOne"
			expect(repo).not.toBeNull()
			expect(repo.entityList.length).toEqual 2

	describe "#getRepository", ->

		it "will return an entity repository", ->
			datastore.buildEntity('ReferenceEntityOne', mocks.datastoreConfig.ReferenceEntityOne[0])
			expect(datastore.getRepository("ReferenceEntityOne").constructor).toEqual EntityRepository

		it "will return the requested repo when it exists", ->
			datastore.buildEntity('ReferenceEntityOne', mocks.datastoreConfig.ReferenceEntityOne[0])
			repo = datastore.getRepository("ReferenceEntityOne")
			expect(repo.entityClass).toEqual ReferenceEntityOne
			expect(repo.find("1")).not.toBeNull()

		it "will return null when the requested repo doesn't exist", ->
			expect(datastore.getRepository "ReferenceEntityOne").toBeNull()

	describe "#find", ->

		it "will return an entity", ->
			datastore.buildEntities("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne)
			entity = datastore.find("ReferenceEntityOne", "1")
			expect(entity).not.toEqual null
			expect(entity.propOne).toEqual "valueOne"

		it "will return null when that entity doesn't exist", ->
			expect(datastore.find('ReferenceEntityOne', 'bad-id')).toBeNull()