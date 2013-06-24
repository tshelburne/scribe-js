# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "scribe-js"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Shelburne"]
  s.date = "2013-06-24"
  s.description = ""
  s.email = "shelburt02@gmail.com"
  s.executables = ["scribe.js"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.rdoc", "bin/scribe.js", "lib/scribe.rb", "lib/scribe/symbols.rb"]
  s.files = ["CHANGELOG", "Gemfile", "Gemfile.lock", "LICENSE", "Manifest", "README.rdoc", "Rakefile", "assets/scripts/coffee/scribe/datastore.coffee", "assets/scripts/coffee/scribe/factory/auto_mapper.coffee", "assets/scripts/coffee/scribe/factory/entity_factory.coffee", "assets/scripts/coffee/scribe/factory/entity_mapper.coffee", "assets/scripts/coffee/scribe/references/reference_builder.coffee", "assets/scripts/coffee/scribe/references/reference_property.coffee", "assets/scripts/coffee/scribe/repositories/entity_metadata.coffee", "assets/scripts/coffee/scribe/repositories/entity_repository.coffee", "bin/scribe.js", "config/assets.rb", "lib/scribe.rb", "lib/scribe/symbols.rb", "scribe-js.gemspec", "spec/jasmine.yml", "spec/runner.html", "spec/support/classes.coffee", "spec/support/example_config.js", "spec/support/helpers.coffee", "spec/support/mocks.coffee", "spec/support/objects.coffee", "spec/support/requirements.coffee", "spec/tests/datastore_spec.coffee", "spec/tests/factory/auto_mapper_spec.coffee", "spec/tests/repositories/entity_metadata_spec.coffee", "spec/tests/repositories/entity_repository_spec.coffee"]
  s.homepage = "https://github.com/tshelburne/scribe-js"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Scribe-js", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "scribe-js"
  s.rubygems_version = "1.8.24"
  s.summary = ""

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jasmine>, [">= 0"])
      s.add_development_dependency(%q<jasmine-headless-webkit>, [">= 0"])
    else
      s.add_dependency(%q<jasmine>, [">= 0"])
      s.add_dependency(%q<jasmine-headless-webkit>, [">= 0"])
    end
  else
    s.add_dependency(%q<jasmine>, [">= 0"])
    s.add_dependency(%q<jasmine-headless-webkit>, [">= 0"])
  end
end
