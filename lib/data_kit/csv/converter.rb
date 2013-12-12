require 'csv'

module DataKit
  module CSV
    class Converter

      attr_accessor :csv
      attr_accessor :analyzer
      attr_accessor :path

      def initialize(csv, analyzer, path)
        @csv = csv
        @analyzer = analyzer

        @path = File.expand_path(path) # output path
      end

      def execute
        writer = ::CSV.open(path, 'wb')

        # Write the header row
        header = []
        analyzer.schema.fields.each do |field|
          header << field.name
        end
        writer << header

        csv.each_row(columns) do |row|
          converted = []
          
          analyzer.schema.fields.each do |field|
            value = row[field.name]

            if value.nil? || field.type == :string || field.type == :empty
              converted << value.to_s
            else
              case field.type
              when :integer
                formatted = DataKit::Converters::Number.reformat(value)
                converted << DataKit::Converters::Integer.convert(formatted)
              when :number
                formatted = DataKit::Converters::Number.reformat(value)
                converted << DataKit::Converters::Number.convert(formatted)
              when :boolean
                converted << DataKit::Converters::Boolean.convert(value)
              when :datetime
                converted << DataKit::Converters::DateTime.convert(value).strftime("%Y-%m-%dT%H:%M:%SZ")
              end
            end
          end

          writer << converted
        end

        writer.close
      end

      class << self
        def convert(csv, analyzer, path)
          converter = new(csv, analyzer, path)
          converter.execute
          converter
        end
      end

      private

      def columns
        @columns ||= analyzer.schema.parser_columns
      end
    end
  end
end