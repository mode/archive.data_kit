require 'spec_helper'

describe DataKit::CSV::Converter do
  let(:tmpdir) {
    Dir.mktmpdir
  }

  let(:target) {
    File.join(tmpdir, 'data.csv')
  }

  let(:csv) {
    DataKit::CSV::Parser.new(data_path('standard.csv'))
  }

  it "should initialize and execute" do
    analysis = DataKit::CSV::SchemaAnalyzer.analyze(csv, :sampling_rate => 1)
    converter = DataKit::CSV::Converter.new(csv, analysis, target)

    converter.execute

    row_count = 0
    CSV.open(target).each { |row| row_count += 1 }
    row_count.should == 11
  end

  it "should convert using the convience method" do
    analysis = DataKit::CSV::SchemaAnalyzer.analyze(csv, :sampling_rate => 1)
    converter = DataKit::CSV::Converter.convert(csv, analysis, target)

    row_count = 0
    CSV.open(target).each { |row| row_count += 1 }
    row_count.should == 11
  end
end