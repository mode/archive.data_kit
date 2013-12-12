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
        
        writer << analyzer.schema.fields.collect(&:name)

        csv.each_row(columns) do |row|
          writer << analyzer.schema.fields.collect do |field|
            convert(row[field.name], field.type)
          end
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

      def convert(value, type)
        if value.nil? || type == :string || type == :empty
          return value.to_s
        else
          formatted = Converters::Number.reformat(value)

          case type
          when :integer
            return Converters::Integer.convert(formatted)
          when :number
            return Converters::Number.convert(formatted)
          when :boolean
            return Converters::Boolean.convert(value)
          when :datetime
            return Converters::DateTime.convert(value).strftime("%Y-%m-%dT%H:%M:%SZ")
          end
        end
      end
    end
  end
end