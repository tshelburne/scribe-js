EntityFactory = require 'scribe/factory/entity_factory'
EntityContainer = require 'scribe/repositories/entity_container'
ReferenceBuilder = require 'scribe/factory/reference_builder'

describe "EntityFactory", ->
	container = factory = null

	beforeEach ->
		container = new EntityContainer()
		referenceBuilder = new ReferenceBuilder(container)
		factory = new EntityFactory(referenceBuilder, [ new ExtensionMapper() ], [ ReferenceEntityOne, ReferenceEntityTwo ])

	describe "#build", ->

		describe "when the mapper for the requested type exists", ->

			it "will build the correct type of entity", ->
				expect(factory.build("ReferenceEntityOne", mocks.datastoreConfig.ReferenceEntityOne[0]).constructor).toEqual ReferenceEntityOne
				expect(factory.build("ReferenceEntityTwo", mocks.datastoreConfig.ReferenceEntityTwo[0]).constructor).toEqual ReferenceEntityTwo
				expect(factory.build("CollectionParentEntity", mocks.datastoreConfig.CollectionParentEntity[0]).constructor).toEqual CollectionParentEntity

			it "will hydrate the entity to the fullest extent possible", ->
				ref1 = new ReferenceEntityOne "1"
				ref2 = new ReferenceEntityOne "2"
				ref3 = new ReferenceEntityTwo "3"
				container.add(ref1)
				container.add(ref2)
				container.add(ref3)
				entity = factory.build "CollectionParentEntity", mocks.datastoreConfig.CollectionParentEntity[0]
				expect(entity.propOne).toEqual "valueOne"
				expect(entity.referenceOne).toEqual ref1
				expect(entity.referenceTwo).toEqual ref3
				expect(entity.referenceCollection).toEqual [ ref1, ref2 ]
				expect(entity.unConfigged).toEqual "Customized"

		it "will return null when the mapper for the requested type does not exist", ->
			expect(factory.build "BadEntityType", { aProperty: "that will never be set" }).toBeNull()