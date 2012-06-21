require 'zlib'

class Exporter
  EXPORT_DIR = 'public/system/exports/'
  
  attr_reader :path
  
  def initialize(file_name, format = 'csv')
    @file_name = file_name
    @format = format
    @path = "#{EXPORT_DIR}#{file_name}"
  end
  
  def perform_export(collection)
    Zlib::GzipWriter.open(@path) do |file|
      collection.each do |entry|
        if @format == 'csv'
          file.puts entry.csv_header
          file.puts entry.export_csv
        elsif @format == 'json'
          file.puts entry.export_json
        elsif @format == 'yml'
          file.puts entry.export_yml
        elsif @format == 'txt'
          file.puts entry.export_txt
        else
          # TODO: Figure out how to access the Rails logger here.
          #logger.warn("Unknown format passed to the Exporter. Defaulting to plain text.")
          file.puts entry.export_txt
        end
      end
    end
  end

end
