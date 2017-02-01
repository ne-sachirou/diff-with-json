require "tempfile"

module DiffWithJson
  class JsonFormatter
    def initialize(@labels : Array(String), @files : Array(String))
    end

    def format : Array(String)
      @files = @files.map { |file| format_one file } if json?
      @files
    end

    def clean
      @files.each { |f| File.delete f } if json?
    end

    def with_formatted(&block : Array(String) ->)
      format
      begin
        yield @files
      ensure
        clean
      end
    end

    private def json?
      !@labels.empty? && @labels.all? { |f| f =~ /\.json(?:\t\(.+\))?$/ }
    end

    private def format_one(file)
      tempfile = Tempfile.new "diff-with-json"
      Process.run "jq", ["-S", ".", file], output: tempfile
      tempfile.flush
      tempfile.path
    end
  end
end
