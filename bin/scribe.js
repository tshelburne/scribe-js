
(function() {
  var modules = window.modules || [];
  var datastoreCache = null;
  var datastoreFunc = function() {
    return (function() {
  var DataStore, EntityContainer, EntityFactory, ReferenceBuilder;

  EntityContainer = require("scribe/repositories/entity_container");

  EntityFactory = require("scribe/factory/entity_factory");

  ReferenceBuilder = require('scribe/factory/reference_builder');

  DataStore = (function() {
    function DataStore(entityFactory, entityContainer) {
      this.entityFactory = entityFactory;
      this.entityContainer = entityContainer;
    }

    DataStore.create = function(customMappers, automappableClasses) {
      var container, factory;

      if (automappableClasses == null) {
        automappableClasses = [];
      }
      container = new EntityContainer();
      factory = new EntityFactory(new ReferenceBuilder(container), customMappers, automappableClasses);
      return new this(factory, container);
    };

    DataStore.prototype.buildEntity = function(entityClass, entityConfig) {
      return this.entityContainer.add(this.entityFactory.build(entityClass, entityConfig));
    };

    DataStore.prototype.buildEntities = function(entityClass, entityConfigs) {
      var config, _i, _len, _results;

      _results = [];
      for (_i = 0, _len = entityConfigs.length; _i < _len; _i++) {
        config = entityConfigs[_i];
        _results.push(this.buildEntity(entityClass, config));
      }
      return _results;
    };

    DataStore.prototype.getRepository = function(entityClass) {
      return this.entityContainer.getRepository(entityClass);
    };

    DataStore.prototype.find = function(entityClass, id) {
      return this.entityContainer.find(entityClass, id);
    };

    return DataStore;

  })();

  return DataStore;

}).call(this);

  };
  modules.scribe__datastore = function() {
    if (datastoreCache === null) {
      datastoreCache = datastoreFunc();
    }
    return datastoreCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var auto_mapperCache = null;
  var auto_mapperFunc = function() {
    return (function() {
  var AutoMapper;

  AutoMapper = (function() {
    var hasProperty, isReferenceCollectionProperty, isReferenceProperty, map;

    function AutoMapper(entityClass, referenceBuilder) {
      this.entityClass = entityClass;
      this.referenceBuilder = referenceBuilder != null ? referenceBuilder : null;
    }

    AutoMapper.prototype.canHandle = function(entityClass) {
      return entityClass === this.entityClass.name;
    };

    AutoMapper.prototype.handle = function(config) {
      var entity;

      entity = map.call(this, config);
      if (typeof this.buildEntity === "function") {
        this.buildEntity(config, entity);
      }
      this.referenceBuilder.hydrateReferencesFor(entity);
      return entity;
    };

    map = function(config) {
      var entity, prop, refIds, value;

      entity = new this.entityClass(config.id);
      for (prop in config) {
        value = config[prop];
        if (hasProperty(entity, prop)) {
          if (isReferenceProperty(value)) {
            this.referenceBuilder.createReference(entity, prop, value["class"], value.id);
          } else if (isReferenceCollectionProperty(value)) {
            refIds = 'id' in value ? value.id : value.ids;
            this.referenceBuilder.createReferenceCollection(entity, prop, value["class"], refIds);
          } else {
            entity[prop] = value;
          }
        }
      }
      return entity;
    };

    hasProperty = function(entity, prop) {
      return prop in entity && !(entity[prop] instanceof Function);
    };

    isReferenceProperty = function(value) {
      return value instanceof Object && 'class' in value && 'id' in value && !(value.id instanceof Array);
    };

    isReferenceCollectionProperty = function(value) {
      return value instanceof Object && 'class' in value && ('ids' in value || ('id' in value && value.id instanceof Array));
    };

    return AutoMapper;

  })();

  return AutoMapper;

}).call(this);

  };
  modules.scribe__factory__auto_mapper = function() {
    if (auto_mapperCache === null) {
      auto_mapperCache = auto_mapperFunc();
    }
    return auto_mapperCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var entity_factoryCache = null;
  var entity_factoryFunc = function() {
    return (function() {
  var AutoMapper, EntityFactory;

  AutoMapper = require('scribe/factory/auto_mapper');

  EntityFactory = (function() {
    var shouldHaveReferenceBuilder;

    function EntityFactory(referenceBuilder, customMappers, automappableClasses) {
      var entityClass, mapper, _i, _j, _len, _len1;

      this.referenceBuilder = referenceBuilder;
      if (automappableClasses == null) {
        automappableClasses = [];
      }
      for (_i = 0, _len = customMappers.length; _i < _len; _i++) {
        mapper = customMappers[_i];
        if (shouldHaveReferenceBuilder(mapper)) {
          mapper.referenceBuilder = this.referenceBuilder;
        }
      }
      this.mappers = customMappers;
      for (_j = 0, _len1 = automappableClasses.length; _j < _len1; _j++) {
        entityClass = automappableClasses[_j];
        this.mappers.push(new AutoMapper(entityClass, this.referenceBuilder));
      }
    }

    EntityFactory.prototype.build = function(entityClass, config) {
      var mapper, _i, _len, _ref;

      _ref = this.mappers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mapper = _ref[_i];
        if (mapper.canHandle(entityClass)) {
          return mapper.handle(config);
        }
      }
      return null;
    };

    shouldHaveReferenceBuilder = function(mapper) {
      return mapper instanceof AutoMapper && (mapper.referenceBuilder == null);
    };

    return EntityFactory;

  })();

  return EntityFactory;

}).call(this);

  };
  modules.scribe__factory__entity_factory = function() {
    if (entity_factoryCache === null) {
      entity_factoryCache = entity_factoryFunc();
    }
    return entity_factoryCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var reference_builderCache = null;
  var reference_builderFunc = function() {
    return (function() {
  var ReferenceBuilder;

  ReferenceBuilder = (function() {
    var PendingReference, addReferenceToCollection, createPendingReference, findPendingReferences, findReference, referenceMatches, removePendingReference, setReference, toCapitalCase;

    function ReferenceBuilder(entityContainer) {
      this.entityContainer = entityContainer;
      this.pendingReferences = [];
    }

    ReferenceBuilder.prototype.createReference = function(entity, prop, refClass, refId) {
      var reference;

      reference = findReference.call(this, refClass, refId);
      if (reference != null) {
        return entity[prop] = reference;
      } else {
        return createPendingReference.call(this, entity, prop, refClass, refId);
      }
    };

    ReferenceBuilder.prototype.createReferenceCollection = function(entity, prop, refClass, refIds) {
      var refId, reference, _i, _len, _results;

      _results = [];
      for (_i = 0, _len = refIds.length; _i < _len; _i++) {
        refId = refIds[_i];
        reference = findReference.call(this, refClass, refId);
        if (reference != null) {
          _results.push(addReferenceToCollection(entity, prop, reference));
        } else {
          _results.push(createPendingReference.call(this, entity, prop, refClass, refId, true));
        }
      }
      return _results;
    };

    ReferenceBuilder.prototype.hydrateReferencesFor = function(entity) {
      var applicablePendingReferences, pendingReference, _i, _len, _results;

      applicablePendingReferences = findPendingReferences.call(this, entity.constructor.name, entity.id);
      _results = [];
      for (_i = 0, _len = applicablePendingReferences.length; _i < _len; _i++) {
        pendingReference = applicablePendingReferences[_i];
        setReference(pendingReference, entity);
        _results.push(removePendingReference.call(this, pendingReference));
      }
      return _results;
    };

    findReference = function(refClass, refId) {
      var _ref;

      return (_ref = this.entityContainer.getRepository(refClass)) != null ? _ref.find(refId) : void 0;
    };

    createPendingReference = function(entity, prop, refClass, refId, isCollection) {
      if (isCollection == null) {
        isCollection = false;
      }
      return this.pendingReferences.push(new PendingReference(entity, prop, refClass, refId, isCollection));
    };

    findPendingReferences = function(refClass, refId) {
      var pendingReference, _i, _len, _ref, _results;

      _ref = this.pendingReferences;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pendingReference = _ref[_i];
        if (referenceMatches(pendingReference, refClass, refId)) {
          _results.push(pendingReference);
        }
      }
      return _results;
    };

    removePendingReference = function(pendingReference) {
      return this.pendingReferences.splice(this.pendingReferences.indexOf(pendingReference), 1);
    };

    referenceMatches = function(pendingReference, refClass, refId) {
      return pendingReference.refClass === refClass && pendingReference.refId === refId;
    };

    setReference = function(pendingReference, reference) {
      if (pendingReference.partOfCollection) {
        return addReferenceToCollection(pendingReference.entity, pendingReference.prop, reference);
      } else {
        return pendingReference.entity[pendingReference.prop] = reference;
      }
    };

    addReferenceToCollection = function(entity, prop, reference) {
      var capitalProp;

      capitalProp = toCapitalCase(prop);
      if (entity["addTo" + capitalProp] != null) {
        return entity["addTo" + capitalProp](reference);
      } else {
        return entity[prop].push(reference);
      }
    };

    toCapitalCase = function(string) {
      return "" + (string.charAt(0).toUpperCase()) + (string.slice(1));
    };

    PendingReference = (function() {
      function PendingReference(entity, prop, refClass, refId, partOfCollection) {
        this.entity = entity;
        this.prop = prop;
        this.refClass = refClass;
        this.refId = refId;
        this.partOfCollection = partOfCollection != null ? partOfCollection : false;
      }

      return PendingReference;

    })();

    return ReferenceBuilder;

  })();

  return ReferenceBuilder;

}).call(this);

  };
  modules.scribe__factory__reference_builder = function() {
    if (reference_builderCache === null) {
      reference_builderCache = reference_builderFunc();
    }
    return reference_builderCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var entity_containerCache = null;
  var entity_containerFunc = function() {
    return (function() {
  var EntityContainer, EntityRepository;

  EntityRepository = require('scribe/repositories/entity_repository');

  EntityContainer = (function() {
    var buildNewRepository;

    function EntityContainer() {
      this.repositories = [];
    }

    EntityContainer.prototype.add = function(entity) {
      var repo;

      repo = this.getRepository(entity);
      if (repo == null) {
        repo = buildNewRepository.call(this, entity);
      }
      return repo.add(entity);
    };

    EntityContainer.prototype.find = function(entityClass, id) {
      var repository;

      repository = this.getRepository(entityClass);
      if (repository != null) {
        return repository.find(id);
      }
      return null;
    };

    EntityContainer.prototype.getRepository = function(entityCheck) {
      var repository, _i, _len, _ref;

      _ref = this.repositories;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        repository = _ref[_i];
        if (repository.canHandle(entityCheck)) {
          return repository;
        }
      }
      return null;
    };

    buildNewRepository = function(entity) {
      var newRepository;

      newRepository = new EntityRepository(entity.constructor);
      this.repositories.push(newRepository);
      return newRepository;
    };

    return EntityContainer;

  })();

  return EntityContainer;

}).call(this);

  };
  modules.scribe__repositories__entity_container = function() {
    if (entity_containerCache === null) {
      entity_containerCache = entity_containerFunc();
    }
    return entity_containerCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var entity_repositoryCache = null;
  var entity_repositoryFunc = function() {
    return (function() {
  var EntityRepository;

  EntityRepository = (function() {
    var isMatch;

    function EntityRepository(entityClass) {
      this.entityClass = entityClass;
      this.entityList = [];
    }

    EntityRepository.prototype.canHandle = function(entityCheck) {
      return this.entityClass === entityCheck || this.entityClass.name === entityCheck || entityCheck.constructor === this.entityClass;
    };

    EntityRepository.prototype.add = function(entity) {
      return this.entityList.push(entity);
    };

    EntityRepository.prototype.remove = function(entity) {
      return this.entityList.splice(this.entityList.indexOf(entity), 1);
    };

    EntityRepository.prototype.find = function(id) {
      var entity, _i, _len, _ref;

      _ref = this.entityList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entity = _ref[_i];
        if (entity.id === id) {
          return entity;
        }
      }
      return null;
    };

    EntityRepository.prototype.findAll = function() {
      return this.entityList;
    };

    EntityRepository.prototype.findBy = function(criteria) {
      var entity, _i, _len, _ref, _results;

      _ref = this.entityList;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entity = _ref[_i];
        if (isMatch(entity, criteria)) {
          _results.push(entity);
        }
      }
      return _results;
    };

    EntityRepository.prototype.findOneBy = function(criteria) {
      var entity, _i, _len, _ref;

      _ref = this.entityList;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entity = _ref[_i];
        if (isMatch(entity, criteria)) {
          return entity;
        }
      }
      return null;
    };

    EntityRepository.prototype.numEntities = function() {
      return this.entityList.length;
    };

    isMatch = function(entity, criteria) {
      var prop, value;

      for (prop in criteria) {
        value = criteria[prop];
        if (entity[prop] !== value) {
          return false;
        }
      }
      return true;
    };

    return EntityRepository;

  })();

  return EntityRepository;

}).call(this);

  };
  modules.scribe__repositories__entity_repository = function() {
    if (entity_repositoryCache === null) {
      entity_repositoryCache = entity_repositoryFunc();
    }
    return entity_repositoryCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  window.require = function(path) {
    var transformedPath = path.replace(/\//g, '__');
    if (transformedPath.indexOf('__') === -1) {
      transformedPath = '__' + transformedPath;
    }
    var factory = modules[transformedPath];
    if (factory === null) {
      return null;
    } else {
      return modules[transformedPath]();
    }
  };
})();
