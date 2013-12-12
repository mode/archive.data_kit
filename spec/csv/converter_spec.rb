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
    analyzer = DataKit::CSV::Analyzer.analyze(csv, :sample_rate => 1)
    converter = DataKit::CSV::Converter.new(csv, analyzer, target)

    converter.execute

    row_count = 0
    CSV.open(target).each { |row| row_count += 1 }
    row_count.should == 11
  end

  it "should convert using the convience method" do
    analyzer = DataKit::CSV::Analyzer.analyze(csv, :sample_rate => 1)
    converter = DataKit::CSV::Converter.convert(csv, analyzer, target)

    row_count = 0
    CSV.open(target).each { |row| row_count += 1 }
    row_count.should == 11
  end
end