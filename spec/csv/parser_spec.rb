require 'spec_helper'

describe DataKit::CSV::Parser do
  it "should initialize" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(path)

    csv.path.should == path
  end

  it "should enumerate rows with a string path" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(path)

    columns = {
      0 => { 'alias' => 'draft_order' },
      1 => { 'alias' => 'player' },
      2 => { 'alias' => 'position' },
      3 => { 'alias' => 'avg_draft_position' },
      4 => { 'alias' => 'avg_bid_value' }
    }

    count = 0
    csv.each_row(columns) do |row|
      count += 1
    end

    count.should == 472
  end

  it "should enumerate rows with an IO path" do
    path = csv_path('espn_draft.csv')
    csv = DataKit::CSV::Parser.new(File.open(path))

    columns = {
      0 => { 'alias' => 'draft_order' },
      1 => { 'alias' => 'player' },
      2 => { 'alias' => 'position' },
      3 => { 'alias' => 'avg_draft_position' },
      4 => { 'alias' => 'avg_bid_value' }
    }

    count = 0
    csv.each_row(columns) do |row|
      count += 1
    end

    count.should == 472
  end
end