module Opener
  class TreeTagger
    ##
    # CLI wrapper around {Opener::TreeTagger} using Slop.
    #
    # @!attribute [r] parser
    #  @return [Slop]
    #
    class CLI
      attr_reader :parser

      def initialize
        @parser = configure_slop
      end

      ##
      # @param [Array] argv
      #
      def run(argv = ARGV)
        parser.parse(argv)
      end

      ##
      # @return [Slop]
      #
      def configure_slop
        return Slop.new(:strict => false, :indent => 2, :help => true) do
          banner 'Usage: tree-tagger [OPTIONS]'

          separator <<-EOF.chomp

About:

    Rule base POS tagging using TreeTagger, supports various languages such as
    Dutch and English. This command reads input from STDIN.

Example:

    cat some_file.kaf | tree-tagger
          EOF

          separator "\nOptions:\n"

          on :v, :version, 'Shows the current version' do
            abort "tree-tagger v#{VERSION} on #{RUBY_DESCRIPTION}"
          end

          on :'no-time', 'Disables adding of dynamic timestamps'

          run do |opts, args|
            if opts[:'no-time']
              args = args + ['--no-time']
            end

            tagger = TreeTagger.new(:args => args)
            input  = STDIN.tty? ? nil : STDIN.read

            puts tagger.run(input)
          end
        end
      end
    end # CLI
  end # TreeTagger
end # Opener
