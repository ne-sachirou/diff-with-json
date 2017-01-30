require "option_parser"

module DiffWithJson
  class App
    def main(argv : Array(String))
      labels = [] of String
      OptionParser.parse! do |parser|
        parser.banner = <<-HELP
        diff-with-json [OPTIONS] FILES...

        diff with JSON structure.

        Example:
        \tdiff-with-json -L a.json -L b.json /tmp/a /tmp/b

        HELP
        parser.on("-u", "") { }
        parser.on("-L LABEL", "") { |label| labels << label }
        parser.on("-h", "--help", "Show help") do
          puts parser
          exit
        end
      end
      files = ARGV.first 2
      labels, files = JsonFormatter.new(labels, files).format
      Diff.new(labels, files).diff
    end
  end
end
