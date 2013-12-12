require 'spec_helper'

describe DataKit::CSV::Parser do
  let(:path) {
    data_path('standard.csv')
  }

  let(:crlf_path) {
    data_path('carriage_returns.csv')
  }

  let(:columns) {
    {
      0 => { 'alias' => 'id' },
      1 => { 'alias' => 'first_name' },
      2 => { 'alias' => 'last_name' },
      3 => { 'alias' => 'email' },
      4 => { 'alias' => 'country' },
      5 => { 'alias' => 'ip_address' },
      6 => { 'alias' => 'amount' },
      7 => { 'alias' => 'active' },
      8 => { 'alias' => 'activated_at' },
      9 => { 'alias' => 'address' }
    }
  }

  it "should initialize" do
    csv = DataKit::CSV::Parser.new(path)

    csv.path.should == path
  end

  it "should enumerate rows with a string path" do
    csv = DataKit::CSV::Parser.new(path)

    count = 0
    csv.each_row(columns) do |row|
      count += 1
    end

    count.should == 10
  end

  it "should enumerate rows with an IO path" do
    csv = DataKit::CSV::Parser.new(File.open(path))

    count = 0
    csv.each_row(columns) do |row|
      count += 1
    end

    count.should == 10
  end

  it "should enumerate rows for lines separated by CRLF" do
    csv = DataKit::CSV::Parser.new(File.open(crlf_path))

    count = 0
    csv.each_row(columns) do |row|
      count += 1
    end

    count.should == 10
  end
end