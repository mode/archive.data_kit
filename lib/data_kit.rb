require "data_kit/version"

# Data I/O
require 'data_kit/csv/parser'
require 'data_kit/csv/analyzer'
require 'data_kit/csv/converter'

# Data Conversion
require 'data_kit/converters/number'
require 'data_kit/converters/integer'
require 'data_kit/converters/boolean'
require 'data_kit/converters/date_time'

# Datasets
require 'data_kit/dataset/field'
require 'data_kit/dataset/schema'
require 'data_kit/dataset/metadata'

# Patches / Fixes
require 'data_kit/patches/rcsv'