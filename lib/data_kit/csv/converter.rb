require 'csv'

module DataKit
  module CSV
    class Converter

      attr_accessor :csv
      attr_accessor :analysis
      attr_accessor :output_path

      def initialize(csv, analysis, output_path)
        @csv = csv
        @analysis = analysis
        @output_path = File.expand_path(output_path)
      end

      def execute
        ::CSV.open(output_path, 'wb') do |writer|
          writer << csv.headers
          csv.each_row do |row|
            writer << csv.headers.collect do |field_name|
              convert(row[field_name], field_types[field_name])
            end
          end
        end
      end

      def field_types
        @field_types ||= analysis.field_types
      end

      class << self
        def convert(csv, analysis, output_path)
          converter = new(csv, analysis, output_path)
          converter.execute
          converter
        end
      end

      private

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