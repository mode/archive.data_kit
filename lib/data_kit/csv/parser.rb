require 'rcsv'

module DataKit
  module CSV
    class Parser
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
          puts row.inspect
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

        @handle.set_encoding(
          Encoding.find("BINARY"), Encoding.find("UTF-8"),
          {:invalid => :replace, :undef => :replace, :replace => ''}
        )
      end

      def set_headers
        handle.rewind
        Rcsv.parse(handle, :header => :none) { |row| @headers = row; break }
      end
    end
  end
end