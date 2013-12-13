require 'rcsv'

module DataKit
  module CSV
    class Parser
      # Encode streams from BINARY into UTF-8
      InternalEnc = Encoding.find("UTF-8")
      ExternalEnc = Encoding.find("BINARY")

      attr_reader :path
      attr_reader :handle
      attr_reader :headers

      def initialize(path)
        @path = path
        
        set_handle
        set_headers
      end

      def each_row(&block)
        handle.rewind
        Rcsv.parse(handle, :header => :skip, :columns => columns, :row_as_hash => true) do |row|
          yield row
        end
      end

      private

      def columns
        index = -1
        @columns ||= headers.inject({}) do |result, field_name|
          index += 1
          result[index] = { :alias => field_name }
          result
        end
      end

      def set_handle
        if path.is_a?(IO)
          @handle = path
        else
          @handle = File.open(path)
        end

        @handle.set_encoding(ExternalEnc, InternalEnc)
      end

      def set_headers
        handle.rewind
        Rcsv.parse(handle, :header => :none) { |row| @headers = row; break }
      end
    end
  end
end