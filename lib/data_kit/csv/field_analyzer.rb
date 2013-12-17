module DataKit
  module CSV
    class FieldAnalyzer
      attr_accessor :csv
      attr_accessor :field_pos
      attr_accessor :match_type
      attr_accessor :sampling_rate

      def initialize(csv, field_pos, options = {})
        @csv = csv
        @field_pos = field_pos
        @match_type = options[:match_type] || :any
        @sampling_rate = options[:sampling_rate] || 0.1
      end

      def execute
        random = Random.new

        field_name = csv.headers[field_pos]
        analysis = TypeMatchAnalysis.new(field_name, { :match_type => match_type })

        csv.each_row do |row|
          analysis.increment_total
          if random.rand <= sampling_rate
            analysis.increment_sample
            analysis.insert(row[field_name])
          end
        end

        analysis
      end
      
      class << self
        def analyze(csv, field_pos, options = {})
          new(csv, field_pos, options).execute
        end
      end
    end
  end
end