#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class to handling hydrating entities anytime a reference entity is built, and maintaining those
# reference until they are hydrated
#
class ReferenceBuilder

	constructor: (@entityContainer)->
		@pendingReferences = []

	createReference: (entity, prop, refClass, refId)->
		reference = findReference.call @, refClass, refId
		if reference? then entity[prop] = reference else createPendingReference.call @, entity, prop, refClass, refId

	createReferenceCollection: (entity, prop, refClass, refIds)->
		for refId in refIds
			reference = findReference.call @, refClass, refId
			if reference? then addReferenceToCollection entity, prop, reference else createPendingReference.call @, entity, prop, refClass, refId, true

	hydrateReferencesFor: (entity)-> 
		applicablePendingReferences = findPendingReferences.call @, entity.constructor.name, entity.id
		for pendingReference in applicablePendingReferences
			setReference pendingReference, entity
			removePendingReference.call @, pendingReference

	# PRIVATE
		
	findReference = (refClass, refId)-> @entityContainer.getRepository(refClass)?.find(refId)

	createPendingReference = (entity, prop, refClass, refId, isCollection=false)-> @pendingReferences.push new PendingReference(entity, prop, refClass, refId, isCollection)

	findPendingReferences = (refClass, refId)-> (pendingReference for pendingReference in @pendingReferences when referenceMatches pendingReference, refClass, refId)

	removePendingReference = (pendingReference)-> @pendingReferences.splice @pendingReferences.indexOf(pendingReference), 1

	referenceMatches = (pendingReference, refClass, refId)-> pendingReference.refClass is refClass and pendingReference.refId is refId
		
	setReference = (pendingReference, reference)->
		if pendingReference.partOfCollection
			addReferenceToCollection pendingReference.entity, pendingReference.prop, reference
		else
			pendingReference.entity[pendingReference.prop] = reference

	addReferenceToCollection = (entity, prop, reference)->
		capitalProp = toCapitalCase prop
		if entity["addTo#{capitalProp}"]?
			entity["addTo#{capitalProp}"](reference)
		else
			entity[prop].push reference

	toCapitalCase = (string)-> "#{string.charAt(0).toUpperCase()}#{string.slice(1)}"


	class PendingReference

		constructor: (@entity, @prop, @refClass, @refId, @partOfCollection=false)->

return ReferenceBuilder