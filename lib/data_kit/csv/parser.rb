require 'rcsv'

module DataKit
  module CSV
    class Parser
      # Encode streams from BINARY into UTF-8
      InternalEncoding = Encoding.find("UTF-8")
      ExternalEncoding = Encoding.find("BINARY")

      attr_accessor :path
      attr_accessor :options

      def initialize(path, options = {})
        @path = path
        @options = options
      end

      def each_row(columns, &block)
        if path.is_a?(IO)
          path.rewind # make sure we can re-enter here
          path.set_encoding(ExternalEncoding, InternalEncoding)
          ::Rcsv.parse(path, :headers => :skip, :columns => columns, :row_as_hash => true).each do |row|
            yield row
          end
        elsif path.is_a?(String)
          handle = File.open(path)
          handle.set_encoding(ExternalEncoding, InternalEncoding)

          ::Rcsv.parse(handle, :headers => :skip, :columns => columns, :row_as_hash => true) do |row|
            yield row
          end
        end
      end
    end
  end
end