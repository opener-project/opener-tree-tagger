#!/usr/bin/env ruby
#
require 'opener/daemons'
require 'opener/tree_tagger'

options = Opener::Daemons::OptParser.parse!(ARGV)
daemon = Opener::Daemons::Daemon.new(Opener::TreeTagger, options)
daemon.start

