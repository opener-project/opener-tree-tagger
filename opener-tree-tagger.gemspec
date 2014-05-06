# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'opener/tree_tagger/version'

Gem::Specification.new do |gem|
  gem.name          = "opener-tree-tagger"
  gem.version       = Opener::TreeTagger::VERSION
  gem.authors       = ["rubenIzquierdo","sparkboxx"]
  gem.email         = ["ruben.izquierdobevia@vu.nl", "wilco@olery.com"]
  gem.description   = %q{Ruby wrapped KAF based Tree Tagger for 6 languages }
  gem.summary       = gem.description
  gem.homepage      = "http://opener-project.github.com/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.bindir        = 'bin'

  gem.add_dependency 'opener-daemons'
  gem.add_dependency 'opener-build-tools', ['>= 0.2.7']
  gem.add_dependency 'rake'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'opener-webservice'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'

end
