require 'smarter_csv'
require 'date'
require 'terminal-table'
require_relative 'helpers'
require_relative 'data_handler'

class Converter < Thor
  desc "Amount converter", "convert different currencies to USD with inflation correlation"

  def parse(file)
    puts "You supplied the file: #{file}"
    parsing_options = {:value_converters => {:processed_at => Helpers::DateConverter,
                                             :currency => Helpers::CurrencyConverter,
                                             :amount => Helpers::AmountConverter}}

    File.open(file, "r:bom|utf-8") do |file|
      file_data = SmarterCSV.process(file, parsing_options)
      data = DataHandler.new(file_data).parse

      rows =[]

      data.each do |country, data|
        data.sort.each do |year, amount|
          rows << [country, year, amount.ceil(2)]
        end
      end

      table = Terminal::Table.new :title => "Currency summarizer", :headings => ['Country', 'Year', 'Amount in USD'], :rows => rows
      puts table
    end

    puts "Parsing was finished successfully"
  end
end