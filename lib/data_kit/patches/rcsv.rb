require "rcsv/rcsv"
require "rcsv/version"

require "stringio"

#
# This is a temporary monkey patch to Rcsv.parse
#  to silence warnings in Ruby 2 about #lines being deprecated
#

class Rcsv
  def self.parse(csv_data, options = {}, &block)
    options[:header] ||= :use
    raw_options = {}

    raw_options[:col_sep] = options[:column_separator] && options[:column_separator][0] || ','
    raw_options[:offset_rows] = options[:offset_rows] || 0
    raw_options[:nostrict] = options[:nostrict]
    raw_options[:parse_empty_fields_as] = options[:parse_empty_fields_as]
    raw_options[:buffer_size] = options[:buffer_size] || 1024 * 1024 # 1 MiB

    if csv_data.is_a?(String)
      csv_data = StringIO.new(csv_data)
    elsif !(csv_data.respond_to?(:lines) && csv_data.respond_to?(:read))
      inspected_csv_data = csv_data.inspect
      raise ParseError.new("Supplied CSV object #{inspected_csv_data[0..127]}#{inspected_csv_data.size > 128 ? '...' : ''} is neither String nor looks like IO object.")
    end

    if csv_data.respond_to?(:external_encoding)
      raw_options[:output_encoding] = csv_data.external_encoding.to_s
    end

    initial_position = csv_data.pos

    first_line = csv_data.each_line.first
    field_count = first_line.split(raw_options[:col_sep]).length

    case options[:header]
    when :use
      header = self.raw_parse(StringIO.new(first_line), raw_options).first
      raw_options[:offset_rows] += 1
    when :skip
      header = (0..field_count).to_a
      raw_options[:offset_rows] += 1
    when :none
      header = (0..field_count).to_a
    end

    raw_options[:row_as_hash] = options[:row_as_hash] # Setting after header parsing

    if options[:columns]
      only_rows = []
      except_rows = []
      row_defaults = []
      column_names = []
      row_conversions = ''

      header.each do |column_header|
        column_options = options[:columns][column_header]
        if column_options
          if (options[:row_as_hash])
            column_names << (column_options[:alias] || column_header)
          end

          row_defaults << column_options[:default] || nil

          only_rows << case column_options[:match]
          when Array
            column_options[:match]
          when nil
            nil
          else
            [column_options[:match]]
          end

          except_rows << case column_options[:not_match]
          when Array
            column_options[:not_match]
          when nil
            nil
          else
            [column_options[:not_match]]
          end

          row_conversions << case column_options[:type]
          when :int
            'i'
          when :float
            'f'
          when :string
            's'
          when :bool
            'b'
          when nil
            's' # strings by default
          else
            fail "Unknown column type #{column_options[:type].inspect}."
          end
        elsif options[:only_listed_columns]
          column_names << nil
          row_defaults << nil
          only_rows << nil
          except_rows << nil
          row_conversions << ' '
        else
          column_names << column_header
          row_defaults << nil
          only_rows << nil
          except_rows << nil
          row_conversions << 's'
        end
      end

      raw_options[:column_names] = column_names if options[:row_as_hash]
      raw_options[:only_rows] = only_rows unless only_rows.compact.empty?
      raw_options[:except_rows] = except_rows unless except_rows.compact.empty?
      raw_options[:row_defaults] = row_defaults unless row_defaults.compact.empty?
      raw_options[:row_conversions] = row_conversions
    end

    csv_data.pos = initial_position
    return self.raw_parse(csv_data, raw_options, &block)
  end
end