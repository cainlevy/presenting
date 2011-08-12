$LOAD_PATH << File.dirname(__FILE__) + '/lib'

Gem::Specification.new do |s|
  s.name = 'presenting'
  s.version = '2.0.0rc1'
  s.authors = ['Lance Ivy']
  s.email = 'lance@cainlevy.net'
  s.homepage = 'http://github.com/cainlevy/presenting'
  s.summary = 'component-style scaffolding helpers'
  s.description = 'Provides view components to quickly render tables, forms, etc., typically for an admin interface.'

  s.files = Dir.glob("lib/**/*") + Dir.glob("app/**/*") + %w(LICENSE README Rakefile config/routes.rb)
  s.test_files = Dir.glob("test/**/*")

  s.add_development_dependency('mocha')
end
