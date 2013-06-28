#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class to handling hydrating entities anytime a reference entity is built, and maintaining those
# reference until they are hydrated
#
class ReferenceBuilder

	constructor: (@entityContainer)->
		@pendingReferences = []

	hydrateReferencesFor: (entity)-> 
		for pendingReference in findPendingReferences.call @, entity.constructor, entity.id
			pendingReference.setReference entity
			removePendingReference.call @, pendingReference

	createReference: (entity, prop, refClass, refId)->
		reference = findReference.call @, refClass, refId
		if reference? then entity[prop] = reference else @pendingReferences.push new PendingReference(entity, prop, refClass, refId)
		
	findReference = (refClass, refId)-> @entityContainer.getRepository(refClass)?.find(refId)

	findPendingReferences = (refClass, refId)-> (pendingReference for pendingReference in @pendingReferences when referenceMatches pendingReference, refClass, refId)

	removePendingReference = (pendingReference)-> @pendingReferences.splice @pendingReferences.indexOf(pendingReference), 1

	referenceMatches = (pendingReference, refClass, refId)-> pendingReference.refClass is refClass and pendingReference.refId is refId


	class PendingReference

		constructor: (@entity, @prop, @refClass, @refId)->

		setReference: (reference)-> @entity[@prop] = reference

return ReferenceBuilder