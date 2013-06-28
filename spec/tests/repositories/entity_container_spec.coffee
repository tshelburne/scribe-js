EntityContainer = require "scribe/repositories/entity_container"
EntityRepository = require 'scribe/repositories/entity_repository'

describe "EntityContainer", ->
	container = null

	beforeEach ->
		container = new EntityContainer()

	describe "#add", ->

		it "will create the repo when it doesn't exist", ->
			expect(container.getRepository("ReferenceEntityOne")).toBeNull()
			container.add(new ReferenceEntityOne("1234"))
			expect(container.getRepository("ReferenceEntityOne")).not.toBeNull()

		it "will add the entity", ->
			entity = new ReferenceEntityOne("1234")
			container.add(entity)
			expect(container.find("ReferenceEntityOne", "1234")).toEqual entity

	describe "#find", ->

		it "will return the entity if it has been added", ->
			entity = new ReferenceEntityOne("1234")
			container.add(entity)
			expect(container.find("ReferenceEntityOne", "1234")).toEqual entity

		it "will return null when the entity hasn't been added", ->
			expect(container.find("ReferenceEntityOne", "1234")).toBeNull()

	describe "#getRepository", ->

		it "will return an entity repository", ->
			container.add(new ReferenceEntityOne("1234"))
			expect(container.getRepository("ReferenceEntityOne").constructor).toEqual EntityRepository

		it "will return the requested repo when it exists", ->
			container.add(new ReferenceEntityOne('1234'))
			repo = container.getRepository "ReferenceEntityOne"
			expect(repo.entityClass).toEqual ReferenceEntityOne

		it "will return null when one doesn't exist", ->
			expect(container.getRepository 'BadEntity').toBeNull()