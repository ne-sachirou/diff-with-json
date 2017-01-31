require "tempfile"

module DiffWithJson
  class JsonFormatter
    def initialize(@labels : Array(String), @files : Array(String))
    end

    def format : Tuple(Array(String), Array(String))
      @files = @files.map { |file| format_one file } if json?
      {@labels, @files}
    end

    private def json?
      !@labels.empty? && @labels.all? { |f| f =~ /\.json(?:\t\(.+\))?$/ }
    end

    private def format_one(file)
      tempfile = Tempfile.new "diff-with-json"
      Process.run "jq", ["-S", ".", file], output: tempfile
      tempfile.path
    end
  end
end
