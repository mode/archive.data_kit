require 'spec_helper'

describe DataKit::CSV::Analyzer do
  it "should initialize" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(path)

    analyzer = DataKit::CSV::Analyzer.new(csv)

    analyzer.csv.should == csv
    analyzer.keys.should == []
    analyzer.row_count.should == 0
    analyzer.sample_count.should == 0
    analyzer.schema.should_not == nil
    analyzer.metadata.should_not == nil
  end

  it "should initialize with keys" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(path)

    analyzer = DataKit::CSV::Analyzer.new(csv, keys: [0, 1])

    analyzer.csv.should == csv
    analyzer.keys.should == [0,1]
    analyzer.row_count.should == 0
    analyzer.sample_count.should == 0
    analyzer.schema.should_not == nil
    analyzer.metadata.should_not == nil
  end

  it "should initialize with an IO" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(File.open(path))

    analyzer = DataKit::CSV::Analyzer.new(csv, keys: [0, 1])

    analyzer.csv.should == csv
    analyzer.keys.should == [0,1]
    analyzer.row_count.should == 0
    analyzer.sample_count.should == 0
    analyzer.schema.should_not == nil
    analyzer.metadata.should_not == nil
  end

  it "should execute an analysis" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(path)

    analyzer = DataKit::CSV::Analyzer.new(csv, keys: [0, 1])

    analyzer.execute

    analyzer.schema.fields.length.should == 5
    analyzer.metadata.type?('draft_order').should == :integer
    analyzer.metadata.type?('player').should == :string
    analyzer.metadata.type?('position').should == :string
    analyzer.metadata.type?('avg_draft_position').should == :number
    analyzer.metadata.type?('avg_bid_value').should == :number

    analyzer.row_count.should == 472
    analyzer.sample_count.should be < 472
  end

  it "should analyze with an IO" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(File.open(path))

    analyzer = DataKit::CSV::Analyzer.new(csv, keys: [0, 1])

    analyzer.execute

    analyzer.schema.fields.length.should == 5
    analyzer.metadata.type?('draft_order').should == :integer
    analyzer.metadata.type?('player').should == :string
    analyzer.metadata.type?('position').should == :string
    analyzer.metadata.type?('avg_draft_position').should == :number
    analyzer.metadata.type?('avg_bid_value').should == :number

    analyzer.row_count.should == 472
    analyzer.sample_count.should be < 472
  end
end