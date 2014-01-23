# encoding: utf-8

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
            value.encode('UTF-8', encoding_opts).gsub(/(\p{Sc}|\,)/, '')
          else
            value
          end
        end

        def encoding_opts
          {:invalid => :replace, :undef => :replace, :replace => '?'}
        end
      end
    end
  end
end