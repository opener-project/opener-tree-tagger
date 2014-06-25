require 'open3'
require 'optparse'
require 'nokogiri'
require 'opener/core'

require_relative 'tree_tagger/version'
require_relative 'tree_tagger/cli'

module Opener
  class TreeTagger
    attr_reader :options, :args

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
      @args    = options.delete(:args) || []
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def run(input)
      stdout, stderr, process = capture(input)

      raise stderr unless process.success?

      return stdout

    rescue Exception => error
      return Opener::Core::ErrorLayer.new(input, error.message, self.class).add
    end

    def capture(input)
      Open3.capture3(*command.split(" "), :stdin_data=>input)
    end

    def command
      return "python -E #{kernel} #{args.join(' ')}"
    end

    protected

    def core_dir
      File.expand_path("../../core", File.dirname(__FILE__))
    end

    def kernel
      File.join(core_dir,'/tt_from_kaf_to_kaf.py')
    end
  end
end
