module DataKit
  module Converters
    class Integer
      class << self
        def convert(value)
          Integer(value)
        end

        def match?(value)
          begin
            Integer(value)
            true
          rescue
            false
          end
        end

        def reformat(value)
          value.tr(',', '').tr('$', '')
        end
      end
    end
  end
end