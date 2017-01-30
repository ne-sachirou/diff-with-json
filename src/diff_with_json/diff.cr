module DiffWithJson
  class Diff
    def initialize(@labels : Array(String), @files : Array(String))
    end

    def diff
      IO.pipe do |reader, writer|
        spawn do
          Process.run diff_cmd, %w(-u) + @labels.flat_map { |l| ["-L", l] } + @files, output: writer
          writer.close
        end
        reader.each_line { |line| puts line }
      end
    end

    private def diff_cmd
      unless `which colordiff`.strip == ""
        "colordiff"
      else
        "diff"
      end
    end
  end
end
