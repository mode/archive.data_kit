require 'spec_helper'

describe DataKit::Dataset::Metadata do  
  it "should initialize" do
    metadata = DataKit::Dataset::Metadata.new

    metadata.types.should == {}
  end

  it "should add a row for analysis" do
    metadata = DataKit::Dataset::Metadata.new

    metadata.add 'field1', '1.0'
    metadata.add 'field1', '2.0'

    metadata.types.should == {
      'field1' => {
        :number => 2
      }
    }
  end

  it "should know the number of rows with a particular type" do
    metadata = DataKit::Dataset::Metadata.new

    metadata.add 'field1', '1.0'
    metadata.add 'field1', '2.0'

    metadata.type_count('field1', :number).should == 2
  end

  it "should determine the type of a field" do
    metadata = DataKit::Dataset::Metadata.new

    metadata.add 'field1', '1.0'
    metadata.add 'field1', '2.0'
    metadata.add 'field2', 'str'
    metadata.add 'field2', 'str2'

    metadata.type?('field1').should == :number
    metadata.type?('field2').should == :string
  end

  it "should infer a string type if there non-numeric mixed types" do
    metadata = DataKit::Dataset::Metadata.new

    metadata.add 'field1', '1.0'
    metadata.add 'field1', '2.0'
    metadata.add 'field2', '2.0'
    metadata.add 'field2', 'str2'

    metadata.type?('field1').should == :number
    metadata.type?('field2').should == :string
  end

  it "should infer a number type if there are mixed numeric types" do
    metadata = DataKit::Dataset::Metadata.new

    metadata.add 'field1', '1.0'
    metadata.add 'field1', '20'
    metadata.add 'field1', nil

    metadata.type?('field1').should == :number
  end
end