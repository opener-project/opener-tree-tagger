require 'open3'
require 'optparse'

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
      @args          = options.delete(:args) || []
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def run(input)
      capture(input)
    end
    
    def capture(input)
      Open3.popen3(*command.split(" ")) {|i, o, e, t|
        out_reader = Thread.new { o.read }
        err_reader = Thread.new { e.read }
        i.write input
        i.close
        [out_reader.value, err_reader.value, t.value]
      }
    end

    def command
      return "#{adjust_python_path} python -E -OO #{kernel} #{args.join(' ')}"
    end
    
    protected
    ##
    # @return [String]
    #
    def adjust_python_path
      site_packages =  File.join(core_dir, 'site-packages')
      "env PYTHONPATH=#{site_packages}:$PYTHONPATH"
    end

    def core_dir
      File.expand_path("../../core", File.dirname(__FILE__))
    end

    def kernel
      File.join(core_dir,'/tt_from_kaf_to_kaf.py')
    end


  end
end
