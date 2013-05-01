DataStore = require "scribe/datastore"
EntityFactory = require "scribe/factory/entity_factory"

describe "DataStore", ->
  datastore = null

  beforeEach ->
    datastore = new DataStore(new EntityFactory())

  it "can generate a repository", ->
    expect(datastore.repos).toEqual []
    datastore.getRepository "NewEntity"
    expect(datastore.repos.length).toEqual 1

  it "can return a repository", ->
    repo = datastore.getRepository "NewEntity"
    expect(repo).not.toBeNull()

  describe "when using EntityFactory", ->
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

    afterEach ->

    it "can build an entity", ->
      datastore.buildEntity("referenceOne", datastoreConfig.referenceOne[0], false)
      repo = datastore.getRepository "referenceOne"
      expect(repo).not.toBeNull()
      expect(repo.findAll().length).toEqual 1
      expect(repo.find("1")).not.toBeNull()
      expect(repo.find("1").propOne).toEqual "valueOne"

    it "can build multiple entities", ->
      datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
      repo = datastore.getRepository "referenceOne"
      expect(repo).not.toBeNull()
      expect(repo.entityList.length).toEqual 2

    it "can build entity references", ->
      datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
      datastore.buildEntities("referenceTwo", datastoreConfig.referenceTwo, false)
      datastore.buildEntities("parent", datastoreConfig.parent)
      repo = datastore.getRepository "parent"
      expect(repo).not.toBeNull()
      expect(repo.numReferenceProperties()).toEqual 2
      entity = repo.find("4")
      expect(entity).not.toBeNull()
      expect(entity.referenceOne).not.toBeNull()
      expect(entity.referenceOne.propOne).toEqual "valueOne"
      expect(entity.referenceTwo.propTwo).toEqual "valueTwo"

    it "can build entity reference collections", ->
      datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
      datastore.buildEntities("referenceTwo", datastoreConfig.referenceTwo, false)
      datastore.buildEntities("collectionParent", datastoreConfig.collectionParent)
      entity = datastore.getRepository("collectionParent").find("5")
      expect(entity.referenceCollection).not.toEqual []
      for ref in entity.referenceCollection
        expect(ref).toBeDefined()
        expect(ref.propOne).toBeDefined()

    it "can find an entity", ->
      datastore.buildEntities("referenceOne", datastoreConfig.referenceOne, false)
      entity = datastore.find("referenceOne", "1")
      expect(entity).not.toEqual null
      expect(entity.propOne).toEqual "valueOne"
