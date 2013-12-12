require 'timeliness'

module DataKit
  module Converters
    class DateTime
      class << self
        def convert(value)
          Timeliness.parse(value, :datetime, :zone => :utc)
        end

        def match?(value)
          Timeliness::Definitions.format_sets(:datetime, value).any?{|set| value =~ set.regexp}
        end

        # Additional Date/Time Formats
        Timeliness.add_formats(:datetime, "yyyy-m-dTh:nn:ss")
        Timeliness.add_formats(:datetime, "m/d/yy h:nn:ss.u ampm")
      end
    end
  end
end