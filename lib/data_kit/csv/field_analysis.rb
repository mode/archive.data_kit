module DataKit
  module CSV
    class FieldAnalysis
      attr_reader :field_name
      attr_reader :match_type

      attr_reader :types # {10 => :string, ...}
      attr_reader :values # {10 => "2010-13-01"}
      attr_reader :row_count
      attr_reader :sample_count

      def initialize(field_name, options = {})
        @field_name = field_name

        @types, @values = {}, {}
        @row_count, @sample_count = 0, 0

        @match_type = options[:match_type] || :any

        Dataset::Field::Types.each do |type|
          @types[type] = []
        end
      end

      def increment_total
        @row_count += 1
      end

      def increment_sample
        @sample_count += 1
      end

      def insert(value)
        value_type = Dataset::Field.type?(value)

        if match_type.nil? || match_type == :any
          insert_value_with_type(value, value_type)
        elsif value_type == match_type
          insert_value_with_type(value, value_type)
        end
      end

      def type?
        if has_single_type?
          type_list.first
        elsif has_only_numeric_types?
          :number
        else
          :string
        end
      end

      def value_at(row_num)
        @values[row_num]
      end

      def type_count(type)
        types[type].length
      end

      def type_list
        types.keys.select{ |type| @types[type].length > 0 }
      end

      def has_single_type?
        (type_list - [:null]).length == 1
      end

      def has_only_numeric_types?
        (type_list - [:integer, :number, :null]).length == 0
      end

    private
      def insert_value_with_type(value, type)
        @values[row_count] = value
        @types[type] << row_count
      end
    end
  end
end