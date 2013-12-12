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
    analyzer.metadata.should_not == nil

    analyzer.row_count.should == 0
    analyzer.sample_count.should == 0
    analyzer.schema.fields.length.should == 10
  end

  it "should initialize schema with an IO" do
    analyzer = DataKit::CSV::Analyzer.new(iocsv)


  end

  it "should execute an analysis" do
    analyzer = DataKit::CSV::Analyzer.new(csv)

    analyzer.execute

    analyzer.schema.fields.length.should == 10
    analyzer.metadata.type?('id').should == :integer
    analyzer.metadata.type?('first_name').should == :string
    analyzer.metadata.type?('last_name').should == :string
    analyzer.metadata.type?('email').should == :string
    analyzer.metadata.type?('country').should == :string
    analyzer.metadata.type?('ip_address').should == :string
    analyzer.metadata.type?('amount').should == :number
    analyzer.metadata.type?('active').should == :boolean
    analyzer.metadata.type?('activated_at').should == :datetime
    analyzer.metadata.type?('address').should == :string

    analyzer.row_count.should == 10
    analyzer.sample_count.should be < 10
  end

  it "should calculate a sample_rate" do
    DataKit::CSV::Analyzer.sample_rate(1024).should == 1
    DataKit::CSV::Analyzer.sample_rate(2048 * 2048).should be < 1
  end
end