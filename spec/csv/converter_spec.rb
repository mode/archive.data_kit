require 'spec_helper'

describe DataKit::CSV::Converter do
  let(:tmpdir) {
    Dir.mktmpdir
  }

  it "should initialize and execute" do
    path = csv_path('format_examples.csv.txt')

    csv = DataKit::CSV::Parser.new(path)
    analyzer = DataKit::CSV::Analyzer.analyze(csv, :sample_rate => 1)

    target = File.join(tmpdir, 'data.csv')
    converter = DataKit::CSV::Converter.new(csv, analyzer, target)

    converter.execute

    row_count = 0
    CSV.open(target).each do |row|
      row_count += 1
    end
    row_count.should == 6
  end
end