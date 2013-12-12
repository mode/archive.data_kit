require 'spec_helper'

describe DataKit::Converters::DateTime do
  it "should match a date" do
    DataKit::Converters::DateTime.match?("1/1/00").should == true
    DataKit::Converters::DateTime.match?("2010-01-01").should == true
    DataKit::Converters::DateTime.match?("2010-01-01 12:00:00").should == true
    DataKit::Converters::DateTime.match?("2000-01-01T00:00:00Z").should == true
    DataKit::Converters::DateTime.match?("2000-01-01T00:00:00+00:00").should == true
    DataKit::Converters::DateTime.match?("10/16/10 18:24").should == true
    DataKit::Converters::DateTime.match?("10/16/10 1:24:15").should == true
  end

  it "should convert dates it can match" do
    {
      '1/1/00' => "2000-01-01 00:00:00",
      '2010-01-01' => '2010-01-01 00:00:00',
      '2010-01-01 12:00:00' => '2010-01-01 12:00:00',
      '2000-01-01T00:00:00' => '2000-01-01 00:00:00',
      '2000-01-01T00:00:00Z' => '2000-01-01 00:00:00',
      '2000-02-01T00:00:00+00:00' => '2000-02-01 00:00:00',
      '10/1/2012 10:27:45.000000 AM' => '2012-10-01 10:27:45',
      '10/1/2012 1:27:45.000000 AM' => '2012-10-01 01:27:45',
      '1/1/2012 1:27:45.000000 AM' => '2012-01-01 01:27:45',
      "10/16/10 18:24" => '2010-10-16 18:24:00'
    }.each do |testcase, result|
      DataKit::Converters::DateTime.convert(testcase).strftime("%Y-%m-%d %H:%M:%S").should == result
    end
  end
end