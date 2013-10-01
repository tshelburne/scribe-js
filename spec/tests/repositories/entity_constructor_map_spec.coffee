EntityConstructorMap = require "scribe/repositories/entity_constructor_map"
DataStore = require 'scribe/datastore'

describe "EntityConstructorMap", ->

	beforeEach ->
		EntityConstructorMap.link "ref1", ReferenceEntityOne

	afterEach ->
		EntityConstructorMap.ctors = {}

	describe "::link", ->

		it "will add the pair to the list of linked constructors", ->
			expect(EntityConstructorMap.find "ref1").toEqual ReferenceEntityOne

	describe "::find", ->

		it "will return the linked constructor", ->
			expect(EntityConstructorMap.find "ref1").toEqual ReferenceEntityOne

		it "will return undefined if the constructor hasn't been linked", ->
			expect(EntityConstructorMap.find "ref2").toBeUndefined()

	describe "::match", ->

		describe "when the constructor name exists in the list of linked constructors", ->

			it "will return true if the constructor matches the linked constructor", ->
				expect(EntityConstructorMap.match 'ref1', ReferenceEntityOne).toBeTruthy()

			it "will return false if the constructor does not match the linked constructor", ->
				expect(EntityConstructorMap.match 'ref1', ReferenceEntityTwo).toBeFalsy()

		describe "when the constructor name does not exist in the list of linked constructors", ->

			describe "and the name of the constructor can be correctly intuited from the constructor itself", ->

				it "will return true if the constructor name matches the given name", ->
					expect(EntityConstructorMap.match 'ReferenceEntityTwo', ReferenceEntityTwo).toBeTruthy()

				it "will return false if the constructor name does not match the given name", ->
					expect(EntityConstructorMap.match 'ReferenceEntityOne', ReferenceEntityTwo).toBeFalsy()

			describe "and the name of the constructor cannot be correctly intuited from the constructor itself (AKA when minified)", ->

				it "will return false", ->
					# although it's strange and kind of "meta", scribe.js is compiled using closure, so using it 
					# as an example of attempting to match minified function names is perfect
					expect(EntityConstructorMap.match 'DataStore', DataStore).toBeFalsy()