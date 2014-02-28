module Opener
  class TreeTagger
    class CLI
      attr_reader :options, :option_parser

      ##
      # @param [Hash] options
      #
      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)

        @option_parser = OptionParser.new do |opts|
          opts.program_name   = 'tree-tagger'
          opts.summary_indent = '  '

          opts.on('-l', '--log', 'Enable logging to STDERR') do
            @options[:logging] = true
          end

          opts.separator <<-EOF

Examples:

  cat example.kaf | #{opts.program_name}    # Basic usage
  cat example.kaf | #{opts.program_name} -l # Logs information to STDERR
          EOF
        end
      end

      ##
      # @param [String] input
      #
      def run(input)
        option_parser.parse!(options[:args])

        tagger = TreeTagger.new(options)

        stdout, stderr, process = tagger.run(input)

        if process.success?
          puts stdout

          if options[:logging] and !stderr.empty?
            STDERR.puts(stderr)
          end
        else
          abort stderr
        end
      end

      private

      ##
      # Shows the help message and exits the program.
      #
      def show_help
        abort option_parser.to_s
      end

      ##
      # Shows the version and exits the program.
      #
      def show_version
        abort "#{option_parser.program_name} v#{VERSION} on #{RUBY_DESCRIPTION}"
      end
    end
  end
end

