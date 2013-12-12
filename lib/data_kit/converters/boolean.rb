module DataKit
  module Converters
    class Boolean
      class << self
        def convert(value)
          downcased = value.downcase
          downcased == 'true' || downcased == 't'
        end

        def match?(value)
          (value =~ /\A(true|t|false|f)\z/i) == 0
        end
      end
    end
  end
end