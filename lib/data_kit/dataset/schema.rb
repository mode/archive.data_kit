module DataKit
  module Dataset
    class Schema
      attr_accessor :fields

      def initialize
        @fields = []
      end

      def keys
        fields.select{ |f| f.key? }
      end

      def to_yaml
        fields.collect(&:to_hash).to_yaml
      end

      def to_package
        DataKit::Package::Schema.new(fields.collect(&:to_package))
      end

      def parser_columns
        columns = {}
        fields.each_with_index do |field, position|
          columns[position] = { :alias => field.name }
        end
        columns
      end
    end
  end
end