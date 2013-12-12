module DataKit
  module Dataset
    class Metadata
      attr_accessor :types

      def initialize
        @types = {}
      end

      def add(field, value)
        type = Field.type?(value)

        @types[field] ||= {}
        @types[field][type] ||= 0
        @types[field][type]  += 1
      end

      def type?(field)
        if has_single_type?(field)
          types[field].keys.first
        elsif has_only_numeric_types?(field)
          :number
        else
          :string
        end
      end

      def type_count(field, type)
        types[field][type] || 0
      end

      def has_single_type?(field)
        types[field].keys.length == 1
      end

      def has_only_numeric_types?(field)
        (types[field].keys - [:integer, :number, :null]).length == 0
      end
    end
  end
end