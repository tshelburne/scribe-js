$: << File.expand_path("#{File.dirname(__FILE__)}/lib")

require 'scribe'

require 'rake'
require 'jasmine-headless-webkit'
require 'keystone'
require 'echoe'

Echoe.new("scribe") do |p|
  p.author = "Tim Shelburne"
  p.email = "shelburt02@gmail.com"
  p.url = "https://github.com/tshelburne/GITHUB_NAME"

  p.ignore_pattern = FileList[".gitignore"]
  p.development_dependencies = [ "jasmine", "jasmine-headless-webkit" ]
end

desc "Default"
task default: :'test:jasmine'

namespace :test do

	desc "Run Jasmine tests"
	Jasmine::Headless::Task.new(jasmine: :assets) do |t|
	  t.colors = true
	  t.keep_on_error = true
	  t.jasmine_config = './spec/jasmine.yml'
	end
	
end

desc "Build assets"
Keystone::RakeTask.new :assets do |t|
  t.config_file = "config/assets.rb"
  t.output_path = 'bin'
end
