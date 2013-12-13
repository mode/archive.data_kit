require 'spec_helper'

describe DataKit::CSV::Analysis do  
  it "should insert a row for analysis" do
    analysis = DataKit::CSV::Analysis.new(['field1'])

    analysis.insert 'field1', '1.0'
    analysis.insert 'field1', '2.0'

    analysis.type_list('field1').should == [:number]
  end

  it "should know the number of rows with a particular type" do
    analysis = DataKit::CSV::Analysis.new(['field1'])

    analysis.insert 'field1', '1.0'
    analysis.insert 'field1', '2.0'

    analysis.type_count('field1', :number).should == 2
  end

  it "should determine the type of a field" do
    analysis = DataKit::CSV::Analysis.new(['field1', 'field2'])

    analysis.insert 'field1', '1.0'
    analysis.insert 'field1', '2.0'
    analysis.insert 'field2', 'str'
    analysis.insert 'field2', 'str2'

    analysis.type?('field1').should == :number
    analysis.type?('field2').should == :string
  end

  it "should infer a string type if there non-numeric mixed types" do
    analysis = DataKit::CSV::Analysis.new(['field1', 'field2'])

    analysis.insert 'field1', '1.0'
    analysis.insert 'field1', '2.0'
    analysis.insert 'field2', '2.0'
    analysis.insert 'field2', 'str2'

    analysis.type?('field1').should == :number
    analysis.type?('field2').should == :string
  end

  it "should infer a number type if there are mixed numeric types" do
    analysis = DataKit::CSV::Analysis.new(['field1'])

    analysis.insert 'field1', '1.0'
    analysis.insert 'field1', '20'
    analysis.insert 'field1', nil

    analysis.type?('field1').should == :number
  end
end