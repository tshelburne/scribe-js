EntityRepository = require 'scribe/repositories/entity_repository'
ReferenceProperty = require 'scribe/references/reference_property'

describe "EntityRepository", ->
	repo = null

	addEntity = (id, propOne)->
		entity = new ReferenceEntityOne(id)
		entity.propOne = propOne
		repo.add entity
		entity

	beforeEach ->
		repo = new EntityRepository('type')

	describe "#canHandle", ->

		it "will return true when the repository handles the given type", ->
			expect(repo.canHandle "type").toBeTruthy()

		it "will return false when the repository does not handle the given type", ->
			expect(repo.canHandle "bad-type").toBeFalsy()

	describe "#add", ->

		it "will add the entity to the repository's list of entities", ->
			repo.add(new ReferenceEntityOne('1234'))
			expect(repo.find('1234')).not.toBeNull()

	describe "#remove", ->

		it "will remove the entity from the repository's list of entities", ->
			entity = addEntity '1234'
			repo.remove(entity)
			expect(repo.find('1234')).toBeNull()

	describe "#find", ->

		it "will return the entity with the given id when it exists", ->
			entity = addEntity '1234'
			expect(repo.find('1234')).toEqual entity

		it "will return null if no entity is found", ->
			expect(repo.find('bad-id')).toBeNull()

	describe "#findAll", ->

		it "will return all entities that have been added to the repository", ->
			entity1 = addEntity '1234'
			entity2 = addEntity '2345'
			expect(repo.findAll()).toEqual [ entity1, entity2 ]

	describe "#findBy", ->
		entity1 = entity2 = entity3 = null

		beforeEach ->
			entity1 = addEntity '1234', 'match'
			entity2 = addEntity '2345', 'no match'
			entity3 = addEntity '3456', 'match'

		it "will return all entities that match the given criteria", ->
			expect(repo.findBy({ 'propOne': 'match' })).toEqual [ entity1, entity3 ]

		it "will return an empty array if no entities match the given criteria", ->
			expect(repo.findBy({ 'propOne': 'bad match' })).toEqual [ ]

	describe "#findOneBy", ->
		entity1 = entity2 = entity3 = null

		beforeEach ->
			entity1 = addEntity '1234', 'match'
			entity2 = addEntity '2345', 'no match'
			entity3 = addEntity '3456', 'match'

		it "will return only the first entity that matches the given criteria", ->
			expect(repo.findOneBy({ 'propOne': 'match' })).toEqual entity1

		it "will return null if no entity matches the given criteria", ->
			expect(repo.findOneBy({ 'propOne': 'bad match' })).toBeNull()

	describe "#numEntities", ->

		it "will return the total number of entities", ->
			expect(repo.numEntities()).toEqual 0
			addEntity '1234'
			expect(repo.numEntities()).toEqual 1
			addEntity '2345'
			expect(repo.numEntities()).toEqual 2

	describe "#hasReferences", ->

		it 'will return true when entities in this repository have one or more reference properties', ->
			entity = new ParentEntity('1234')
			entity.referenceOne = new ReferenceProperty('referenceOne', '1245')
			repo.add(entity)
			expect(repo.hasReferences()).toBeTruthy()

		it 'will return false when entities in this repository have no reference properties', ->
			repo.add(new ReferenceEntityOne('1234'))
			expect(repo.hasReferences()).toBeFalsy()

		it 'will return null when no entities have been added to this repository', ->
			expect(repo.hasReferences()).toBeNull()

	describe "#numReferenceProperties", ->

		it 'will return the number of reference properties', ->
			entity = new CollectionParentEntity('1234')
			entity.referenceOne = new ReferenceProperty('referenceOne', '1245')
			entity.referenceTwo = new ReferenceProperty('referenceTwo', '1246')
			entity.referenceCollection = [ new ReferenceProperty('referenceOne', '1235') ]
			repo.add(entity)
			expect(repo.numReferenceProperties()).toEqual 2

		it 'will return null when no entities have been added to this repository', ->
			expect(repo.numReferenceProperties()).toBeNull()

	describe "#numReferenceCollections", ->

		it 'will return the number of reference collection properties', ->
			entity = new CollectionParentEntity('1234')
			entity.referenceOne = new ReferenceProperty('referenceOne', '1245')
			entity.referenceTwo = new ReferenceProperty('referenceTwo', '1246')
			entity.referenceCollection = [ new ReferenceProperty('referenceOne', '1235') ]
			repo.add(entity)
			expect(repo.numReferenceCollections()).toEqual 1

		it 'will return null when no entities have been added to this repository', ->
			expect(repo.numReferenceCollections()).toBeNull()