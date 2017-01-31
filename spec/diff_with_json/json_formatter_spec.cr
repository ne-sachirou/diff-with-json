require "../spec_helper"
require "tempfile"

private def prepare_json_ab
  file = Tempfile.new "json_formatter_spec"
  file.print %({"a":42,"b":57})
  file.flush
  file
end

private def prepare_json_ba
  file = Tempfile.new "json_formatter_spec"
  file.print %({"b":42,"a":57})
  file.flush
  file
end

describe DiffWithJson::JsonFormatter do
  describe "#format" do
    it "dose nothing when labels don't end with json" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      labels, files = DiffWithJson::JsonFormatter.new(["ab", "ba"], [ab.path, ba.path]).format
      labels.should eq ["ab", "ba"]
      files.should eq [ab.path, ba.path]
      File.read(files[0]).should eq %({"a":42,"b":57})
      File.read(files[1]).should eq %({"b":42,"a":57})
    end

    it "dose nothing when one of a label dosen't end with json" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      labels, files = DiffWithJson::JsonFormatter.new(["ab.json", "ba"], [ab.path, ba.path]).format
      labels.should eq ["ab.json", "ba"]
      files.should eq [ab.path, ba.path]
      File.read(files[0]).should eq %({"a":42,"b":57})
      File.read(files[1]).should eq %({"b":42,"a":57})
    end

    it "formats json when both labels end with json" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      labels, files = DiffWithJson::JsonFormatter.new(["ab.json", "ba.json"], [ab.path, ba.path]).format
      labels.should eq ["ab.json", "ba.json"]
      files.should_not eq [ab.path, ba.path]
      File.read(files[0]).should eq %({\n  "a": 42,\n  "b": 57\n}\n)
      File.read(files[1]).should eq %({\n  "a": 57,\n  "b": 42\n}\n)
    end

    it "formats json when both labels are svn-diff style json file name" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      labels, files = DiffWithJson::JsonFormatter.new(["ab.json\t(revision 111)", "ab.json\t(working copy)"], [ab.path, ba.path]).format
      labels.should eq ["ab.json\t(revision 111)", "ab.json\t(working copy)"]
      files.should_not eq [ab.path, ba.path]
      File.read(files[0]).should eq %({\n  "a": 42,\n  "b": 57\n}\n)
      File.read(files[1]).should eq %({\n  "a": 57,\n  "b": 42\n}\n)
    end
  end
end
