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

	datastoreConfig =
		referenceOne: [
			{ id:"1", propOne:"valueOne" },
			{ id:"2", propOne:"valueTwo" }
		]
		referenceTwo: [
			{ id:"3", propOne:"valueOne", propTwo:"valueTwo" }
		]
		parent: [
			{ id:"4", propOne:"valueOne", referenceOne:"1", referenceTwo:"3" }
		]
		collectionParent: [
			{ id:"5", propOne:"valueOne", referenceOne:"1", referenceTwo:"3", referenceCollection: [ "1", "2" ] }
		]

	beforeEach ->
		datastore = new DataStore(entityFactory)

	describe "#buildEntity", ->

		it "will build an entity", ->
			datastore.buildEntity("referenceOne", datastoreConfig.referenceOne[0], false)
			entity = datastore.find "referenceOne", "1"
			expect(entity).not.toBeNull()
			expect(entity instanceof ReferenceEntityOne).toBeTruthy()

		it "will create a repository if one doesn't exist", ->
			datastore.buildEntity("referenceOne", datastoreConfig.referenceOne[0], false)
			expect(datastore.getRepository "referenceOne").not.toBeNull()

		it "will add the entity to the repository", ->
			datastore.buildEntity("referenceOne", datastoreConfig.referenceOne[0], false)
			entity = datastore.getRepository("referenceOne").find("1")
			expect(entity).not.toBeNull()
			expect(entity.propOne).toEqual "valueOne"

		it "will build entity references when buildReferences is true", ->
			datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
			datastore.buildEntities("referenceTwo", datastoreConfig.referenceTwo, false)
			datastore.buildEntities("parent", datastoreConfig.parent)
			entity = datastore.find("parent", "4")
			expect(entity.referenceOne).not.toBeNull()
			expect(entity.referenceOne.propOne).toEqual "valueOne"
			expect(entity.referenceTwo.propTwo).toEqual "valueTwo"

		it "will build entity reference collections when buildReferences is true", ->
			datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
			datastore.buildEntities("referenceTwo", datastoreConfig.referenceTwo, false)
			datastore.buildEntities("collectionParent", datastoreConfig.collectionParent)
			entity = datastore.find("collectionParent", "5")
			expect(entity.referenceCollection).not.toEqual []
			for ref in entity.referenceCollection
				expect(ref).toBeDefined()
				expect(ref.propOne).toBeDefined()

	describe "#buildEntities", ->

		it "will build multiple entities", ->
			datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
			repo = datastore.getRepository "referenceOne"
			expect(repo).not.toBeNull()
			expect(repo.entityList.length).toEqual 2

	describe "#getRepository", ->

		it "will return an entity repository", ->
			expect(datastore.getRepository "referenceOne" instanceof EntityRepository).toBeTruthy()

		it "will return the requested repo when it exists", ->
			datastore.buildEntity('referenceOne', datastoreConfig.referenceOne[0], false)
			expect(datastore.getRepository "referenceOne").toEqual datastore.repos[0]

		it "will create a repository when one doesn't exist", ->
			expect(datastore.repos).toEqual [ ]
			repo = datastore.getRepository "referenceOne"
			expect(datastore.repos).toEqual [ repo ]

	describe "#find", ->

		it "will return an entity", ->
			datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
			entity = datastore.find("referenceOne", "1")
			expect(entity).not.toEqual null
			expect(entity.propOne).toEqual "valueOne"

		it "will return null when that entity doesn't exist", ->
			expect(datastore.find('referenceOne', 'bad-id')).toBeNull()