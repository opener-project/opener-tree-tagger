require File.expand_path('../lib/opener/tree_tagger/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "opener-tree-tagger"
  gem.version     = Opener::TreeTagger::VERSION
  gem.authors     = ["rubenIzquierdo", "sparkboxx"]
  gem.email       = ["ruben.izquierdobevia@vu.nl", "wilco@olery.com"]
  gem.description = %q{Ruby wrapped KAF based Tree Tagger for 6 languages}
  gem.summary     = gem.description
  gem.homepage    = "http://opener-project.github.com/"
  gem.extensions  = ['ext/hack/Rakefile']

  gem.license = 'Apache 2.0'

  gem.files = Dir.glob([
    'core/*',
    'exec/*',
    'ext/**/*',
    'lib/**/*',
    'config.ru',
    '*.gemspec',
    '*_requirements.txt',
    'README.md',
    'LICENSE.txt',
    'task/*'
  ]).select { |file| File.file?(file) }

  gem.executables = Dir.glob('bin/*').map { |file| File.basename(file) }

  gem.add_dependency 'newrelic_rpm', '~> 3.0'

  gem.add_dependency 'opener-daemons', '~> 2.1'
  gem.add_dependency 'opener-webservice', '~> 2.1'
  gem.add_dependency 'opener-core', '~> 2.0'

  gem.add_dependency 'rake'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'cliver'
  gem.add_dependency 'slop', '~> 3.5'

  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'cucumber'
end
