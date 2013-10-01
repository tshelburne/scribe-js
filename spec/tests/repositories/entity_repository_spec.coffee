EntityRepository = require 'scribe/repositories/entity_repository'
EntityConstructorMap = require 'scribe/repositories/entity_constructor_map'

describe "EntityRepository", ->
	repo = null

	addEntity = (id, propOne)->
		entity = new ReferenceEntityOne(id)
		entity.propOne = propOne
		repo.add entity
		entity

	beforeEach ->
		repo = new EntityRepository(ReferenceEntityOne)

	afterEach ->
		EntityConstructorMap.ctors = []

	describe "#canHandle", ->

		describe "will return true when", ->

			beforeEach ->
				addEntity('1234', 'one')

			it "the constructor name is passed in", ->
				expect(repo.canHandle "ReferenceEntityOne").toBeTruthy()

			it "the constructor itself is passed in", ->
				expect(repo.canHandle ReferenceEntityOne).toBeTruthy()

			it "an instance of the constructor is passed in", ->
				expect(repo.canHandle(new ReferenceEntityOne('2345'))).toBeTruthy()

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