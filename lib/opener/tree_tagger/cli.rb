module Opener
  class TreeTagger
    class CLI
      attr_reader :argv, :options, :option_parser

      ##
      # @param [Array] argv
      # @param [Hash] options
      #
      def initialize(argv, options = {})
        @argv    = argv
        @options = DEFAULT_OPTIONS.merge(options)

        @option_parser = OptionParser.new do |opts|
          opts.program_name   = 'tree-tagger'
          opts.summary_indent = '  '

          opts.separator "\nOptions:\n\n"

          opts.on('-l', '--log', 'Enable logging to STDERR') do
            @options[:logging] = true
          end

          opts.on('--no-time', 'Disables adding of timestamps') do
            @options[:args] << '--no-time'
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
        option_parser.parse!(argv)

        tagger = TreeTagger.new(options)

        puts tagger.run(input)
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

