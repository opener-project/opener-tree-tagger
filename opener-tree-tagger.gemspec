require File.expand_path('../lib/opener/tree_tagger/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "opener-tree-tagger"
  gem.version     = Opener::TreeTagger::VERSION
  gem.authors     = ["rubenIzquierdo", "sparkboxx"]
  gem.email       = ["ruben.izquierdobevia@vu.nl", "wilco@olery.com"]
  gem.description = %q{Ruby wrapped KAF based Tree Tagger for 6 languages }
  gem.summary     = gem.description
  gem.homepage    = "http://opener-project.github.com/"
  gem.extensions  = ['ext/hack/Rakefile']

  gem.files = Dir.glob([
    'core/*',
    'exec/*',
    'ext/**/*',
    'lib/**/*',
    'config.ru',
    '*.gemspec',
    '*_requirements.txt',
    'README.md'
  ]).select { |file| File.file?(file) }

  gem.executables = Dir.glob('bin/*').map { |file| File.basename(file) }

  gem.add_dependency 'opener-daemons'
  gem.add_dependency 'opener-build-tools', ['>= 0.2.7']
  gem.add_dependency 'rake'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'puma'
  gem.add_dependency 'opener-webservice'
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
end
