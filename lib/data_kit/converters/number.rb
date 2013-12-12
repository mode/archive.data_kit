module DataKit
  module Converters
    class Number
      class << self
        def convert(value)
          Float(value)
        end

        def match?(value)
          begin
            Float(value)
            true
          rescue
            false
          end
        end

        def reformat(value)
          if value.is_a?(String)
            value.gsub(/(\p{Sc}|\,)/, '')
          else
            value
          end
        end
      end
    end
  end
end