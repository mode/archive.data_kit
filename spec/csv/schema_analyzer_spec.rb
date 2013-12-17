require 'spec_helper'

describe DataKit::CSV::SchemaAnalyzer do
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
    analyzer = DataKit::CSV::SchemaAnalyzer.new(csv)

    analyzer.csv.should == csv
    analyzer.keys.should == []
    analyzer.sampling_rate.should == 0.1
  end

  it "should initialize schema with an IO" do
    analyzer = DataKit::CSV::SchemaAnalyzer.new(iocsv)

    analyzer.csv.should == iocsv
    analyzer.keys.should == []
    analyzer.sampling_rate.should == 0.1
  end

  it "should execute an analysis" do
    analysis = DataKit::CSV::SchemaAnalyzer.new(csv, :sampling_rate => 0.5).execute

    puts analysis.inspect

    analysis.type?('id').should == :integer
    analysis.type?('first_name').should == :string
    analysis.type?('last_name').should == :string
    analysis.type?('email').should == :string
    analysis.type?('country').should == :string
    analysis.type?('ip_address').should == :string
    analysis.type?('amount').should == :number
    analysis.type?('active').should == :boolean
    analysis.type?('activated_at').should == :datetime
    analysis.type?('address').should == :string

    analysis.row_count.should == 10
    analysis.sample_count.should be < 10
  end

  it "should calculate a sampling_rate" do
    DataKit::CSV::SchemaAnalyzer.sampling_rate(1024).should == 1
    DataKit::CSV::SchemaAnalyzer.sampling_rate(2048 * 2048).should be < 1
  end
end