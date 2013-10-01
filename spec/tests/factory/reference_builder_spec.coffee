ReferenceBuilder = require 'scribe/factory/reference_builder'
EntityContainer = require 'scribe/repositories/entity_container'
EntityConstructorMap = require 'scribe/repositories/entity_constructor_map'

describe "ReferenceBuilder", ->
	builder = container = null

	beforeEach ->
		container = new EntityContainer()
		builder = new ReferenceBuilder(container)

	afterEach ->
		EntityConstructorMap.ctors = []

	describe "#createReference", ->

		it "will set the reference property to the reference entity when the entity has been added to the entity container", ->
			entity = new ParentEntity("1234")
			reference = new ReferenceEntityOne("1234")
			container.add(reference)
			builder.createReference(entity, "referenceOne", "ReferenceEntityOne", "1234")
			expect(entity.referenceOne).toEqual reference

		it "will leave the reference property null until the reference entity is registered via @hydrateReferencesFor", ->
			entity = new ParentEntity("1234")
			builder.createReference(entity, "referenceOne", "ReferenceEntityOne", "1234")
			expect(entity.referenceOne).toBeNull()

	describe "#createReferenceCollection", ->

		describe "when the entities have been added to the entity container", ->
			entity = ref1 = ref2 = null

			beforeEach ->
				entity = new CollectionParentEntity("1234")
				ref1 = new ReferenceEntityOne("1234")
				ref2 = new ReferenceEntityOne("2345")
				container.add(ref1)
				container.add(ref2)
				
			it "will set the reference collection property to the reference entities", ->
				builder.createReferenceCollection(entity, "referenceCollection", "ReferenceEntityOne", [ "1234", "2345" ])
				expect(entity.referenceCollection).toEqual [ ref1, ref2 ]

			describe "and a function with the form 'addTo...' exists on the entity, where ... is replaced with a title-cased property name", ->
				
				beforeEach ->
					CollectionParentEntity::addToReferenceCollection = (ref)->
						@timesCalled = 0 unless @timesCalled?
						@referenceCollection.push ref
						@timesCalled += 1
				
				afterEach ->
					delete CollectionParentEntity::addToReferenceCollection

				it "will build a reference collection using addTo... instead of setting the property", ->
					builder.createReferenceCollection(entity, "referenceCollection", "ReferenceEntityOne", [ "1234", "2345" ])
					expect(entity.timesCalled).toEqual 2
					expect(entity.referenceCollection).toEqual [ ref1, ref2 ]

		it "will leave the reference property empty until the reference entities are registered via @hydrateReferencesFor", ->
			entity = new CollectionParentEntity("1234")
			builder.createReferenceCollection(entity, "referenceCollection", "ReferenceEntityOne", [ "1234", "2345" ])
			expect(entity.referenceCollection).toEqual []

	describe "#hydrateReferencesFor", ->

		it "will set all pending references that match to the entity passed in", ->
			entity1 = new ParentEntity "1234"
			entity2 = new CollectionParentEntity "1234"
			ref1 = new ReferenceEntityOne "1234"
			builder.createReference(entity1, "referenceOne", "ReferenceEntityOne", "1234")
			builder.createReferenceCollection(entity2, "referenceCollection", "ReferenceEntityOne", [ "1234", "2345" ])
			expect(entity1.referenceOne).toBeNull()
			expect(entity2.referenceCollection).toEqual []
			builder.hydrateReferencesFor ref1
			expect(entity1.referenceOne).toEqual ref1
			expect(entity2.referenceCollection).toEqual [ ref1 ]