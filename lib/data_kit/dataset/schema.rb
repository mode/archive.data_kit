require 'yaml'

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
    end
  end
end