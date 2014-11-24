#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/tree_tagger'

daemon = Opener::Daemons::Daemon.new(Opener::TreeTagger)

daemon.start
