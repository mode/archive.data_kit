module DataKit
  module Dataset
    class Field

      Types = [:string, :integer, :number, :datetime, :boolean, :null].freeze

      attr_accessor :name
      attr_accessor :key
      attr_accessor :type

      def initialize(name, options = {})
        @name = name
        @key = options[:key] || false
        @type = (options[:type] || :string).to_sym
      end

      def key?
        key == true
      end

      def to_hash
        { 'name' => name, 'type' => type.to_s, 'key' => key?}
      end

      def to_package
        DataKit::Package::Field.new(name, type)
      end

      class << self
        def type?(value)
          return :null if value.nil?
          reformatted = DataKit::Converters::Number.reformat(value)

          if DataKit::Converters::Integer.match?(reformatted)
            :integer
          elsif DataKit::Converters::Number.match?(reformatted)
            :number
          elsif DataKit::Converters::Boolean.match?(value)
            :boolean
          elsif DataKit::Converters::DateTime.match?(value)
            :datetime
          else
            :string
          end
        end

        def convert(value, type)
          return nil if type == :null || value.nil?

          case type
          when :integer
            reformatted = DataKit::Converters::Number.reformat(value)
            DataKit::Converters::Integer.convert(reformatted)
          when :number
            reformatted = DataKit::Converters::Number.reformat(value)
            DataKit::Converters::Number.convert(reformatted)
          when :boolean   then DataKit::Converters::Boolean.convert(value)
          when :datetime  then DataKit::Converters::DateTime.convert(value)
          else value.to_s end
        end
      end
    end
  end
end