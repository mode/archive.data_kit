require 'spec_helper'

describe DataKit::Converters::Integer do
  it "should match values" do
    ["100", "-100", "1,000", "$1,000"].each do |integer|
      reformatted = DataKit::Converters::Integer.reformat(integer)
      DataKit::Converters::Integer.match?(reformatted).should == true
    end
  end

  it "should convert value it can match" do
    {
      "100" => 100, "-100" => -100,
      "1,000" => 1000, "$1,000" => 1000
    }.each do |testcase, result|
      reformatted = DataKit::Converters::Integer.reformat(testcase)
      DataKit::Converters::Integer.convert(reformatted).should == result
    end
  end
end