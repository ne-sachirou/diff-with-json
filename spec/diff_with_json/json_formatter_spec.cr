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
    it "dose nothing when labels are empty" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      formatter = DiffWithJson::JsonFormatter.new [] of String, [ab.path, ba.path]
      files = formatter.format
      files.should eq [ab.path, ba.path]
      File.read(files[0]).should eq %({"a":42,"b":57})
      File.read(files[1]).should eq %({"b":42,"a":57})
      formatter.clean
      [ab, ba].each &.delete
    end

    it "dose nothing when labels don't end with json" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      formatter = DiffWithJson::JsonFormatter.new ["ab", "ba"], [ab.path, ba.path]
      files = formatter.format
      files.should eq [ab.path, ba.path]
      File.read(files[0]).should eq %({"a":42,"b":57})
      File.read(files[1]).should eq %({"b":42,"a":57})
      formatter.clean
      [ab, ba].each &.delete
    end

    it "dose nothing when one of a label dosen't end with json" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      formatter = DiffWithJson::JsonFormatter.new ["ab.json", "ba"], [ab.path, ba.path]
      files = formatter.format
      files.should eq [ab.path, ba.path]
      File.read(files[0]).should eq %({"a":42,"b":57})
      File.read(files[1]).should eq %({"b":42,"a":57})
      formatter.clean
      [ab, ba].each &.delete
    end

    it "formats json when both labels end with json" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      formatter = DiffWithJson::JsonFormatter.new ["ab.json", "ba.json"], [ab.path, ba.path]
      files = formatter.format
      files.should_not eq [ab.path, ba.path]
      File.read(files[0]).should eq %({\n  "a": 42,\n  "b": 57\n}\n)
      File.read(files[1]).should eq %({\n  "a": 57,\n  "b": 42\n}\n)
      formatter.clean
      [ab, ba].each &.delete
    end

    it "formats json when both labels are svn-diff style json file name" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      formatter = DiffWithJson::JsonFormatter.new ["ab.json\t(revision 111)", "ab.json\t(working copy)"], [ab.path, ba.path]
      files = formatter.format
      files.should_not eq [ab.path, ba.path]
      File.read(files[0]).should eq %({\n  "a": 42,\n  "b": 57\n}\n)
      File.read(files[1]).should eq %({\n  "a": 57,\n  "b": 42\n}\n)
      formatter.clean
      [ab, ba].each &.delete
    end
  end

  describe "#clean" do
    it "deletes formatted files" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      formatter = DiffWithJson::JsonFormatter.new ["ab.json", "ba.json"], [ab.path, ba.path]
      files = formatter.format
      formatter.clean
      File.exists?(files[0]).should be_false
      File.exists?(files[1]).should be_false
      File.exists?(ab.path).should be_true
      File.exists?(ba.path).should be_true
      [ab, ba].each &.delete
    end

    it "dosen't delete un-formatted files" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      formatter = DiffWithJson::JsonFormatter.new ["ab", "ba"], [ab.path, ba.path]
      files = formatter.format
      formatter.clean
      File.exists?(files[0]).should be_true
      File.exists?(files[1]).should be_true
      File.exists?(ab.path).should be_true
      File.exists?(ba.path).should be_true
      [ab, ba].each &.delete
    end
  end

  describe "#with_formatted" do
    it "formats JOSN files and clean them" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      called? = false
      formatted_files = [] of String
      DiffWithJson::JsonFormatter.new(["ab.json", "ba.json"], [ab.path, ba.path]).with_formatted do |files|
        called? = true
        formatted_files = files
        files.should_not eq [ab.path, ba.path]
        File.read(files[0]).should eq %({\n  "a": 42,\n  "b": 57\n}\n)
        File.read(files[1]).should eq %({\n  "a": 57,\n  "b": 42\n}\n)
      end
      called?.should be_true
      File.exists?(formatted_files[0]).should be_false
      File.exists?(formatted_files[1]).should be_false
      File.exists?(ab.path).should be_true
      File.exists?(ba.path).should be_true
      [ab, ba].each &.delete
    end

    it "dosen't format no JSON files and dosen't clean them" do
      ab = prepare_json_ab
      ba = prepare_json_ba
      called? = false
      DiffWithJson::JsonFormatter.new(["ab", "ba"], [ab.path, ba.path]).with_formatted do |files|
        called? = true
        files.should eq [ab.path, ba.path]
        File.read(files[0]).should eq %({"a":42,"b":57})
        File.read(files[1]).should eq %({"b":42,"a":57})
      end
      called?.should be_true
      File.exists?(ab.path).should be_true
      File.exists?(ba.path).should be_true
      [ab, ba].each &.delete
    end
  end
end
