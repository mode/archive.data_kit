require 'spec_helper'

describe DataKit::Converters::Boolean do
  it "should match values" do
    ['true', 't', 'false', 'f'].each do |testcase|
      DataKit::Converters::Boolean.match?(testcase).should == true
    end
  end

  it "should convert value it can match" do
    {
      "true" => true, "t" => true,
      "false" => false, "f" => false
    }.each do |testcase, result|
      DataKit::Converters::Boolean.convert(testcase).should == result
    end
  end
end