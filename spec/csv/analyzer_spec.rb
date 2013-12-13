require 'spec_helper'

describe DataKit::CSV::Analyzer do
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
    analyzer = DataKit::CSV::Analyzer.new(csv)

    analyzer.csv.should == csv
    analyzer.keys.should == []
    analyzer.sample_rate.should == 0.1
  end

  it "should initialize schema with an IO" do
    analyzer = DataKit::CSV::Analyzer.new(iocsv)

    analyzer.csv.should == iocsv
    analyzer.keys.should == []
    analyzer.sample_rate.should == 0.1
  end

  it "should execute an analysis" do
    analysis = DataKit::CSV::Analyzer.new(csv, :sample_rate => 0.5).execute

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

  it "should calculate a sample_rate" do
    DataKit::CSV::Analyzer.sample_rate(1024).should == 1
    DataKit::CSV::Analyzer.sample_rate(2048 * 2048).should be < 1
  end
end