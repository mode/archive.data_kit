require 'spec_helper'

describe DataKit::CSV::Parser do
  let(:path) {
    data_path('standard.csv')
  }

  let(:crlf_path) {
    data_path('carriage_returns.csv')
  }

  let(:vc_companies_path) {
    data_path('vc_backed_companies.csv')
  }

  it "should initialize" do
    csv = DataKit::CSV::Parser.new(path)

    csv.path.should == path
  end

  it "should enumerate rows with a string path" do
    csv = DataKit::CSV::Parser.new(path)

    count = 0
    csv.each_row do |row|
      count += 1
    end

    count.should == 10
  end

  it "should enumerate rows with an IO path" do
    csv = DataKit::CSV::Parser.new(File.open(path))

    count = 0
    csv.each_row do |row|
      count += 1
    end

    count.should == 10
  end

  it "should enumerate rows for lines separated by CRLF" do
    csv = DataKit::CSV::Parser.new(File.open(crlf_path))

    count = 0
    csv.each_row do |row|
      count += 1
    end

    count.should == 10
  end

  it "should parse CSVs with unknown encodings" do
    csv = DataKit::CSV::Parser.new(File.open(vc_companies_path))

    count = 0
    csv.each_row do |row|
      count += 1
    end

    count.should == 2
  end
end