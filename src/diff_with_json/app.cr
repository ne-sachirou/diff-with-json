require "option_parser"

module DiffWithJson
  class App
    def main(argv : Array(String))
      labels, files = parse_argv argv
      output_help_then_exit if files.empty?
      JsonFormatter.new(labels, files).with_formatted { |files| Diff.new(labels, files).diff }
    end

    private def parse_argv(argv)
      labels = [] of String
      @parser = OptionParser.parse(argv) do |parser|
        parser.banner = <<-HELP
        diff-with-json [OPTIONS] FILES...

        \tdiff with JSON structure.

        Example:
        \tdiff-with-json -L a.json -L b.json /tmp/a /tmp/b

        Options:
        HELP
        parser.on("-u", "--unified", "") { }
        parser.on("-L LABEL", "--label=LABEL", "Use LABEL instead of file name.") { |label| labels << label }
        parser.on("-h", "--help", "Output this help.") do
          puts parser
          exit
        end
      end
      {labels, argv.first(2)}
    end

    private def output_help_then_exit
      puts @parser if @parser
      exit
    end
  end
end
