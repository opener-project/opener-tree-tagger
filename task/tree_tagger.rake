# This Rake task takes care of setting up a local (in ./tmp) installation of the
# TreeTagger program used by this OpeNER component. Sadly TreeTagger is a total
# pain to install and not shipped with Debian and other distributions. Yay
# software!
#
# Once installed you can set your TREE_TAGGER_PATH as following:
#
#     export TREE_TAGGER_PATH=./tmp/tree_tagger

# The name of the TreeTagger archive to download. Currently only Linux and OS X
# are supported.
if RbConfig::CONFIG['build_os'].include?('darwin')
  archive = 'tree-tagger-MacOSX-3.2-intel.tar.gz'
else
  archive = 'tree-tagger-linux-3.2.tar.gz'
end

tagging_archive = 'tagger-scripts.tar.gz'
installer       = 'install-tagger.sh'

parameter_tasks = []
parameter_files = [
  'dutch-par-linux-3.2-utf8.bin.gz',
  'english-par-linux-3.2-utf8.bin.gz',
  'french-par-linux-3.2-utf8.bin.gz',
  'german-par-linux-3.2-utf8.bin.gz',
  'italian-par-linux-3.2-utf8.bin.gz',
  'spanish-par-linux-3.2-utf8.bin.gz',
  'english-chunker-par-linux-3.2-utf8.bin.gz',
  'french-chunker-par-linux-3.2-utf8.bin.gz',
  'german-chunker-par-linux-3.2-utf8.bin.gz'
]

base_url      = 'http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/data/'
archive_url   = base_url + archive
tagging_url   = base_url + tagging_archive
installer_url = base_url + installer

tmp_target          = 'tmp/tree_tagger'
tmp_executable      = File.join(tmp_target, 'bin/tree-tagger')
tmp_archive         = File.join(tmp_target, archive)
tmp_tagging_archive = File.join(tmp_target, tagging_archive)
tmp_installer       = File.join(tmp_target, installer)

# Downloads the base TreeTagger code
file(tmp_archive) do |task|
  sh "wget #{archive_url} -O #{task.name} --quiet"
end

# Downloads the tagging scripts.
file(tmp_tagging_archive) do |task|
  sh "wget #{tagging_url} -O #{task.name} --quiet"
end

# Downloads the installer script.
file(tmp_installer) do |task|
  sh "wget #{installer_url} -O #{task.name} --quiet"
end

directory(tmp_target) do |task|
  sh "mkdir -p #{task.name}"
end

parameter_files.each do |name|
  task_name = File.join(tmp_target, name)
  input_url = base_url + name

  parameter_tasks << task_name

  file(task_name) do |task|
    sh "wget #{input_url} -O #{task.name} --quiet"
  end
end

file(tmp_executable) do |task|
  # Downloaded half the internet, lets actually install TreeTagger.
  Dir.chdir(tmp_target) do
    sh "bash #{installer}"

    # TreeTagger at some point dropped the "-utf8" suffix from tagging scripts
    # located in cmd/, this however only applies to newer versions of the
    # tagging scripts. To support both we'll simply symlink these files.
    #
    # In case you're wondering: no, TreeTagger doesn't version the tagging
    # scripts, as such this could break again at any point in time.
    Dir['cmd/tree-tagger-*'].each do |cmd_file|
      cmd_file = File.expand_path(cmd_file)
      suffixed = cmd_file + '-utf8'

      sh "ln -s #{cmd_file} #{suffixed}"
      sh "chmod +x #{suffixed}"
    end
  end
end

build_requirements = [
  tmp_target,
  tmp_archive,
  tmp_tagging_archive,
  tmp_installer
] + parameter_tasks + [tmp_executable]

desc 'Installs a local copy of TreeTagger'
task :tree_tagger => build_requirements
