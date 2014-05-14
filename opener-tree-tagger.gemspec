require File.expand_path('../lib/opener/tree_tagger/version', __FILE__)

generated = Dir.glob('core/site-packages/pre_build/**/*')

Gem::Specification.new do |gem|
  gem.name          = "opener-tree-tagger"
  gem.version       = Opener::TreeTagger::VERSION
  gem.authors       = ["rubenIzquierdo","sparkboxx"]
  gem.email         = ["ruben.izquierdobevia@vu.nl", "wilco@olery.com"]
  gem.description   = %q{Ruby wrapped KAF based Tree Tagger for 6 languages }
  gem.summary       = gem.description
  gem.homepage      = "http://opener-project.github.com/"

  gem.files       = (`git ls-files`.split("\n") + generated).sort
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'opener-daemons'
  gem.add_dependency 'opener-build-tools', ['>= 0.2.7']
  gem.add_dependency 'rake'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'opener-webservice'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
end
