AutoMapper = require 'scribe/factory/auto_mapper'
ReferenceProperty = require 'scribe/references/reference_property'

describe "AutoMapper", ->
	mapper = null

	beforeEach ->
		mapper = new AutoMapper(CollectionParentEntity)

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

			it "will set basic properties on the entity", ->
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				expect(entity.propOne).toEqual 'valueOne'

			it "will set reference properties on the entity", ->
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				ref1 = entity.referenceOne
				expect(ref1).not.toBeNull()
				expect(ref1.constructor).toEqual ReferenceProperty
				expect(ref1.entityClass).toEqual 'ReferenceEntityOne'
				expect(ref1.entityId).toEqual '1'
				ref2 = entity.referenceTwo
				expect(ref2).not.toBeNull()
				expect(ref2.constructor).toEqual ReferenceProperty
				expect(ref2.entityClass).toEqual 'ReferenceEntityTwo'
				expect(ref2.entityId).toEqual '3'

			it "will set collection reference properties on the entity", ->
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				collection = entity.referenceCollection
				expect(collection[0]).not.toBeNull()
				expect(collection[0].constructor).toEqual ReferenceProperty
				expect(collection[0].entityClass).toEqual 'ReferenceEntityOne'
				expect(collection[0].entityId).toEqual '1'
				expect(collection[1]).not.toBeNull()
				expect(collection[1].constructor).toEqual ReferenceProperty
				expect(collection[1].entityClass).toEqual 'ReferenceEntityOne'
				expect(collection[1].entityId).toEqual '2'

			describe "when a function with the form 'addTo...' exists, where ... is replaced with a title-cased property name", ->

				beforeEach ->
					CollectionParentEntity::addToReferenceCollection = (ref)->
						@timesCalled = 0 unless @timesCalled?
						@referenceCollection.push ref
						@timesCalled += 1
				
				afterEach ->
					delete CollectionParentEntity::addToReferenceCollection

				it "will build a reference collection using addTo... instead of setting the property", ->
					entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
					expect(entity.timesCalled).toEqual 2
					collection = entity.referenceCollection
					expect(collection[0]).not.toBeNull()
					expect(collection[0].constructor).toEqual ReferenceProperty
					expect(collection[0].entityClass).toEqual 'ReferenceEntityOne'
					expect(collection[0].entityId).toEqual '1'
					expect(collection[1]).not.toBeNull()
					expect(collection[1].constructor).toEqual ReferenceProperty
					expect(collection[1].entityClass).toEqual 'ReferenceEntityOne'
					expect(collection[1].entityId).toEqual '2'

		describe "when @buildEntity() exists on an extension class", ->

			it "will call @buildEntity after automapping to allow for custom mapping", ->
				mapper = new ExtensionMapper()
				spyOn(mapper, 'buildEntity').andCallThrough()
				entity = mapper.handle mocks.datastoreConfig.CollectionParentEntity[0]
				expect(mapper.buildEntity).toHaveBeenCalled()
				expect(entity.unConfigged).toEqual 'Customized'