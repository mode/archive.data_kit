module DataKit
  module CSV
    class SchemaAnalysis
      attr_reader :fields
      attr_reader :types
      attr_reader :row_count
      attr_reader :sample_count

      attr_reader :type_hints
      attr_reader :use_type_hints

      def initialize(fields, options = {})
        @fields, @types = fields, {}
        @row_count, @sample_count = 0, 0

        @type_hints = {}

        if options[:use_type_hints].nil? || options[:use_type_hints] == true
          @use_type_hints = true
        else
          @use_type_hints = false
        end

        fields.each do |field_name|
          @types[field_name] = {}
          @type_hints[field_name] = :string
          Dataset::Field::Types.each do |type|
            @types[field_name][type] = 0
          end
        end
      end

      def increment_total
        @row_count += 1
      end

      def increment_sample
        @sample_count += 1
      end

      def insert(field_name, value)
        if use_type_hints
          type = Dataset::Field.type?(value, type_hints[field_name])
          @type_hints[field_name] = type # cache the most recent type
        else
          type = Dataset::Field.type?(value)
        end

        @types[field_name][type] += 1
      end

      def field_types
        fields.inject({}) do |result, field_name|
          result[field_name] = type?(field_name)
          result
        end
      end

      def type?(field)
        if has_single_type?(field)
          type_list(field).first
        elsif has_only_numeric_types?(field)
          :number
        else
          :string
        end
      end

      def type_count(field, type)
        types[field][type] || 0
      end

      def type_list(field)
        types[field].keys.select do |type|
          type_count(field, type) > 0
        end
      end

      def has_single_type?(field)
        (type_list(field) - [:null]).length == 1
      end

      def has_only_numeric_types?(field)
        (type_list(field) - [:integer, :number, :null]).length == 0
      end
    end
  end
end