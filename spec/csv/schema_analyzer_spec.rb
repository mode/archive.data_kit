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
    analyzer.use_type_hints.should == true
  end

  it "should initialize with type hints turned off" do
    analyzer = DataKit::CSV::SchemaAnalyzer.new(csv, :use_type_hints => false)
    analyzer.use_type_hints.should == false
  end

  it "should initialize schema with an IO" do
    analyzer = DataKit::CSV::SchemaAnalyzer.new(iocsv)

    analyzer.csv.should == iocsv
    analyzer.keys.should == []
    analyzer.sampling_rate.should == 0.1
  end

  it "should execute an analysis with type hints" do
    analysis = DataKit::CSV::SchemaAnalyzer.new(csv, :sampling_rate => 0.5).execute

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
    analysis.use_type_hints.should == true
  end

  it "should execute an analysis without type hints" do
    analysis = DataKit::CSV::SchemaAnalyzer.new(csv,
                :sampling_rate => 0.5, :use_type_hints => false).execute

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
    analysis.use_type_hints.should == false
  end

  it "should execute an analysis with the convenience method" do
    analysis = DataKit::CSV::SchemaAnalyzer.analyze(csv,
                :sampling_rate => 0.5, :use_type_hints => false)

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
    analysis.use_type_hints.should == false
  end

  it "should calculate a sampling_rate" do
    DataKit::CSV::SchemaAnalyzer.sampling_rate(1024).should == 1
    DataKit::CSV::SchemaAnalyzer.sampling_rate(2048 * 2048).should be < 1
  end
end