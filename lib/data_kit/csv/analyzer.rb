module DataKit
  module CSV
    class Analyzer

      attr_accessor :csv
      attr_accessor :keys

      attr_accessor :schema
      attr_accessor :metadata
      attr_accessor :row_count

      attr_accessor :sample_rate
      attr_accessor :sample_count

      def initialize(csv, options = {})
        @csv = csv
        @keys = options[:keys] || []
        @sample_rate = options[:sample_rate] || 0.5

        @row_count = 0
        @sample_count = 0

        @schema = DataKit::Dataset::Schema.new
        @metadata = DataKit::Dataset::Metadata.new

        # Initialize the schema
        populate_schema_fields!
      end

      def execute
        randomness = Random.new

        csv.each_row(schema.parser_columns) do |row|
          @row_count += 1
          if randomness.rand <= sample_rate        
            @sample_count += 1
            schema.fields.each do |field|
              metadata.add(field.name, row[field.name])
            end
          end
        end

        # Update the schema
        update_schema_fields!
      end
      
      class << self
        def analyze(csv, options = {})
          analyzer = new(csv,
            :keys => options[:keys],
            :sample_rate => options[:sample_rate]
          )

          analyzer.execute
          analyzer
        end

        def sample_rate(file_size)
          if file_size < (1024 * 1024)
            sample_rate = 1.0
          else
            scale_factor = 500
            sample_rate = (scale_factor / Math.sqrt(file_size)).round(4)
          end
        end
      end

      private

      def update_schema_fields!
        schema.fields.each do |field|
          field.type = metadata.type?(field.name)
        end
      end

      def populate_schema_fields!
        if csv.path.is_a?(IO)
          line = csv.path.readline
        else
          line = File.open(csv.path, &:readline)
        end
        
        line = line.gsub(/\r\n?/, "\n").split("\n").first

        headers ||= line.split(',').collect(&:chomp)
        headers.each_with_index  do |header, index|
          schema.fields << DataKit::Dataset::Field.new(header, :key => keys.include?(index))
        end
      end
    end
  end
end