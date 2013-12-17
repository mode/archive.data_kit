module DataKit
  module CSV
    class SchemaAnalyzer
      attr_accessor :csv
      attr_accessor :keys
      attr_accessor :sampling_rate
      
      def initialize(csv, options = {})
        @csv = csv
        @keys = options[:keys] || []
        @sampling_rate = options[:sampling_rate] || 0.1
      end

      def execute
        random = Random.new
        analysis = SchemaAnalysis.new(csv.headers)

        csv.each_row do |row|
          analysis.increment_total
          if random.rand <= sampling_rate
            analysis.increment_sample
            row.keys.each do |field_name|
              analysis.insert(field_name.to_s, row[field_name])
            end
          end
        end

        analysis
      end
      
      class << self
        def analyze(csv, options = {})
          analyzer = new(csv,
            :keys => options[:keys],
            :sampling_rate => options[:sampling_rate]
          )

          analyzer.execute
        end

        def sampling_rate(file_size)
          if file_size < (1024 * 1024)
            sampling_rate = 1.0
          else
            scale_factor = 500
            sampling_rate = (scale_factor / Math.sqrt(file_size)).round(4)
          end
        end
      end
    end
  end
end