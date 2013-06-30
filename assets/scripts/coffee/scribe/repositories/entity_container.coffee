EntityRepository = require 'scribe/repositories/entity_repository'

class EntityContainer

	constructor: ->
		@repositories = []

	add: (entity)-> 
		repo = @getRepository entity
		repo = buildNewRepository.call @, entity unless repo?
		repo.add(entity)

	find: (entityClass, id)-> 
		repository = @getRepository entityClass
		return repository.find(id) if repository?
		null

	getRepository: (entityCheck)->
		return repository for repository in @repositories when repository.canHandle entityCheck
		null

	# PRIVATE
		
	buildNewRepository = (entity)->
		newRepository = new EntityRepository(entity.constructor)
		@repositories.push newRepository
		newRepository

return EntityContainer