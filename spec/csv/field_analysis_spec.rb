require 'spec_helper'

describe DataKit::CSV::FieldAnalysis do  
  it "should increment totals and samples" do
    analysis = DataKit::CSV::FieldAnalysis.new('field1')

    analysis.increment_total
    analysis.increment_total

    analysis.increment_sample

    analysis.row_count.should == 2
    analysis.sample_count.should == 1
  end

  it "should insert a row for analysis" do
    analysis = DataKit::CSV::FieldAnalysis.new('field1')

    analysis.insert '1.0'
    analysis.insert '2.0'

    analysis.type?.should == :number
    analysis.has_single_type?.should == true
    analysis.has_only_numeric_types?.should == true
    analysis.type_count(:number).should == 2
  end

  it "should return the value for a specific row" do
    analysis = DataKit::CSV::FieldAnalysis.new('field1')

    analysis.increment_total
    analysis.insert '1.0'

    analysis.increment_total
    analysis.insert '2.0'

    analysis.value_at(1).should == '1.0'
  end

  it "should infer a string type if there non-numeric mixed types" do
    analysis = DataKit::CSV::FieldAnalysis.new('field1')

    analysis.insert '1.0'
    analysis.insert '2.0'
    analysis.insert '2.0'
    analysis.insert 'str2'

    analysis.type?.should == :string
  end

  it "should infer a number type if there are mixed numeric types" do
    analysis = DataKit::CSV::FieldAnalysis.new('field1')

    analysis.insert '1.0'
    analysis.insert '20'
    analysis.insert nil

    analysis.type?.should == :number
  end

  it "should filter analysis to a specific type" do
    analysis = DataKit::CSV::FieldAnalysis.new('field1', :match_type => :number)

    analysis.insert '1.0'
    analysis.insert '20'
    analysis.insert nil
    analysis.insert 'str2'

    analysis.type?.should == :number
  end
end