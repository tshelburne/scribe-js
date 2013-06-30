AutoMapper = require 'scribe/factory/auto_mapper'

EntityContainer = require 'scribe/repositories/entity_container'
ReferenceBuilder = require 'scribe/factory/reference_builder'

describe "AutoMapper", ->
	mapper = container = null

	beforeEach ->
		container = new EntityContainer()
		referenceBuilder = new ReferenceBuilder(container)
		mapper = new AutoMapper(CollectionParentEntity, referenceBuilder)

	describe "#canHandle", ->

		it "will return true when the entity class matches the entity constructor's name", ->
			expect(mapper.canHandle 'CollectionParentEntity').toBeTruthy()

		it "will return false when the entity class doesn't match", ->
			expect(mapper.canHandle 'badClass').toBeFalsy()

	describe "#handle", ->

		it "will return a new entity of the requested type", ->
			entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
			expect(entity).not.toBeNull()
			expect(entity.constructor).toEqual CollectionParentEntity

		it "will not set a property in the configuration that isn't found on the entity", ->
			entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
			expect(entity.mismatchedProperty).toBeUndefined()

		describe "when property names and configuration property names match", ->
			ref1 = ref2 = ref3 = null

			beforeEach ->
				ref1 = new ReferenceEntityOne "1"
				ref2 = new ReferenceEntityOne "2"
				ref3 = new ReferenceEntityTwo "3"
				container.add ref1
				container.add ref2
				container.add ref3

			it "will set basic properties on the entity", ->
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				expect(entity.propOne).toEqual 'valueOne'

			it "will set reference properties on the entity", ->
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				expect(entity.referenceOne).toEqual ref1
				expect(entity.referenceTwo).toEqual ref3

			it "will set collection reference properties on the entity", ->
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				expect(entity.referenceCollection).toEqual [ ref1, ref2 ]

		describe "when buildEntity() exists on an extension class", ->

			it "will call buildEntity after automapping to allow for custom mapping", ->
				mapper = new ExtensionMapper(new ReferenceBuilder(container))
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				expect(entity.unConfigged).toEqual 'Customized'