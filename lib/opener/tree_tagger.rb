require 'open3'
require 'optparse'

require_relative 'tree_tagger/version'
require_relative 'tree_tagger/cli'

module Opener
  class TreeTagger
    attr_reader :options

    ##
    # Hash containing the default options to use.
    #
    # @return [Hash]
    #
    DEFAULT_OPTIONS = {
      :args => []
    }.freeze

    ##
    # @param [Hash] options
    #
    # @option options [Array] :args Collection of arbitrary arguments to pass
    #  to the underlying kernel.
    #
    def initialize(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def run(input)
      return Open3.capture3(command, :stdin_data=>input)
    end

    def command
      "python -E -O #{kernel} #{options[:args].join(' ')}"
    end

    def core_dir
      File.expand_path("../../core", File.dirname(__FILE__))
    end

    def kernel
      File.join(core_dir,'/tt_from_kaf_to_kaf.py')
    end


  end
end
