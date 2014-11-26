desc 'Runs the tests'
task :test => :compile do
  ENV['TREE_TAGGER_PATH'] = File.expand_path('../../tmp/tree_tagger', __FILE__)

  sh('cucumber features')
end
