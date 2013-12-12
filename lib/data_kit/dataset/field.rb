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

      class << self
        def type?(value)
          return :null if value.nil?
          reformatted = Converters::Number.reformat(value)

          if Converters::Integer.match?(reformatted)
            :integer
          elsif Converters::Number.match?(reformatted)
            :number
          elsif Converters::Boolean.match?(value)
            :boolean
          elsif Converters::DateTime.match?(value)
            :datetime
          else
            :string
          end
        end

        def convert(value, type)
          return nil if type == :null || value.nil?
          reformatted = Converters::Number.reformat(value)

          case type
          when :integer  then Converters::Integer.convert(reformatted)
          when :number   then Converters::Number.convert(reformatted)
          when :boolean  then Converters::Boolean.convert(value)
          when :datetime then Converters::DateTime.convert(value)
          else value.to_s
          end
        end
      end
    end
  end
end