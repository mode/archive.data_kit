require 'csv'

module DataKit
  module CSV
    class Parser
      attr_reader :path
      attr_reader :handle
      attr_reader :headers

      def initialize(path)
        @path = path
        set_handle      
      end

      def each_row(&block)
        first = true
        handle.rewind
        
        ::CSV.parse(handle, converters: nil) do |row|
          if first == true
            first = false
            @headers = row
          else
            yield row
          end
        end
      end

      private

      def set_handle
        if path.is_a?(IO)
          @handle = path
        else
          @handle = File.open(path)
        end

        @handle.set_encoding(
          Encoding.find("BINARY"), Encoding.find("UTF-8"),
          {:invalid => :replace, :undef => :replace, :replace => ''}
        )
      end
    end
  end
end