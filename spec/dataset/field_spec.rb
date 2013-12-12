require 'spec_helper'

describe DataKit::Dataset::Field do
  it "should initialize" do
    field = DataKit::Dataset::Field.new('field_name')

    field.name.should == 'field_name'
    field.key?.should == false
    field.type.should == :string
  end

  it "should serialize" do
    field = DataKit::Dataset::Field.new('field_name')

    field.to_hash.should == {
      'name' => 'field_name', 'type' => 'string', 'key' => false
    }
  end

  it "should infer nil types" do
    DataKit::Dataset::Field.type?(nil).should == :null
  end

  it "should infer integer types" do
    DataKit::Dataset::Field.type?("100").should == :integer
    DataKit::Dataset::Field.type?("-100").should == :integer
    DataKit::Dataset::Field.type?("1,000").should == :integer
    DataKit::Dataset::Field.type?("$1,000").should == :integer
  end

  it "should infer numeric types" do
    DataKit::Dataset::Field.type?("100.0").should == :number
    DataKit::Dataset::Field.type?("-100.5").should == :number
    DataKit::Dataset::Field.type?("5.6E11").should == :number
    DataKit::Dataset::Field.type?("-1,000.0").should == :number
    DataKit::Dataset::Field.type?("$1,000.0").should == :number
  end

  it "should infer date types" do
    DataKit::Dataset::Field.type?("2010-01-01").should == :datetime

    # Excel makes everyone sad
    DataKit::Dataset::Field.type?("1/1/00").should == :datetime
  end

  it "should infer date/time types" do
    DataKit::Dataset::Field.type?("2010-01-01 12:00:00").should == :datetime
  end

  it "should infer boolean types" do
    DataKit::Dataset::Field.type?("true").should == :boolean
    DataKit::Dataset::Field.type?("false").should == :boolean
  end

  it "should infer string types" do
    DataKit::Dataset::Field.type?("true5").should == :string
    DataKit::Dataset::Field.type?("my string").should == :string
  end

  it "should convert nil values" do
    DataKit::Dataset::Field.convert(nil, :string).should == nil
  end

  it "should convert integer values" do
    DataKit::Dataset::Field.convert("100", :integer).should == 100
    DataKit::Dataset::Field.convert("-100", :integer).should == -100
    DataKit::Dataset::Field.convert("1,000", :integer).should == 1_000
    DataKit::Dataset::Field.convert("$1,000", :integer).should == 1_000
  end

  it "should convert numeric values" do
    DataKit::Dataset::Field.convert("100.0", :number).should == 100.0
    DataKit::Dataset::Field.convert("-100.0", :number).should == -100.0
    DataKit::Dataset::Field.convert("-1,000.0", :number).should == -1_000.0
    DataKit::Dataset::Field.convert("5E5", :number).should == 500000.0
    DataKit::Dataset::Field.convert("$1,000.0", :number).should == 1000.0
  end

  it "should convert boolean values" do
    DataKit::Dataset::Field.convert("true", :boolean).should == true
    DataKit::Dataset::Field.convert("false", :boolean).should == false
  end

  it "should convert date values" do
    DataKit::Dataset::Field.convert("2010-01-01", :datetime).strftime("%Y-%m-%d %H:%M:%S").should == '2010-01-01 00:00:00'
  end

  it "should convert date/time values" do
    DataKit::Dataset::Field.convert("2010-01-01 12:00:00", :datetime).strftime("%Y-%m-%d %H:%M:%S").should == '2010-01-01 12:00:00'
  end

  it "should convert string values" do
    DataKit::Dataset::Field.convert(500, :string).should == "500"
  end
end