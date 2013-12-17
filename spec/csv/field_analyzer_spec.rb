require 'spec_helper'

describe DataKit::CSV::FieldAnalyzer do
  let(:path) {
    data_path('standard.csv')
  }

  let(:csv) {
    DataKit::CSV::Parser.new(path)
  }

  let(:iocsv) {
    DataKit::CSV::Parser.new(File.open(path))
  }

  it "should initialize" do
    analyzer = DataKit::CSV::FieldAnalyzer.new(csv, 1)

    analyzer.csv.should == csv
    analyzer.field_pos.should == 1
    analyzer.sampling_rate.should == 0.1
  end

  it "should initialize schema with an IO" do
    analyzer = DataKit::CSV::FieldAnalyzer.new(iocsv, 1)

    analyzer.csv.should == iocsv
    analyzer.field_pos.should == 1
    analyzer.sampling_rate.should == 0.1
  end

  it "should execute an analysis" do
    analysis = DataKit::CSV::FieldAnalyzer.new(csv, 8, :sampling_rate => 0.5).execute

    analysis.type?.should == :datetime # activated_at

    analysis.row_count.should == 10
    analysis.sample_count.should be < 10
  end

  it "should analyze using the static convenience method" do
    analysis = DataKit::CSV::FieldAnalyzer.analyze(csv, 8, :sampling_rate => 0.5)
    analysis.type?.should == :datetime # activated_at
  end
end