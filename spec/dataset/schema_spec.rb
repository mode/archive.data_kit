require 'spec_helper'

describe DataKit::Dataset::Schema do  
  it "should initialize" do
    schema = DataKit::Dataset::Schema.new
    schema.fields.should == []
  end

  it "should return a list of keys" do
    schema = DataKit::Dataset::Schema.new
    schema.fields << DataKit::Dataset::Field.new('field')
    schema.fields << DataKit::Dataset::Field.new('field2', key: true)

    schema.keys.length.should == 1
  end

  it "should serialize to yaml" do
    schema = DataKit::Dataset::Schema.new
    schema.fields << DataKit::Dataset::Field.new('field')
    schema.to_yaml.should == schema.fields.collect(&:to_hash).to_yaml
  end
end