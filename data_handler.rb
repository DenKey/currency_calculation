require_relative 'historical_data'

class DataHandler
  attr_reader :data

  USD = 'usd'.freeze

  def initialize(data)
    @data = data
  end

  def parse
    @data.each_with_object({}) do |record, hash|
      country_code = record[:customer_country_code]
      year = record[:processed_at].year.to_s

      hash[country_code] ||= {}
      hash[country_code][year] ||= 0
      hash[country_code][year] +=  calculate_inflation(year, currency_correlation(record))
    end
  end

  private

  def calculate_inflation(from_year, amount, to_year = '2022')
   (amount * HistoricalData::US_INFLATION.fetch(to_year) / HistoricalData::US_INFLATION.fetch(from_year)).ceil(2)
  end

  def currency_correlation(record)
    amount = record[:amount].to_f
    currency = record[:currency]
    processed_at = record[:processed_at]
    return amount if currency == USD

    year = processed_at.year.to_s
    month = processed_at.strftime('%b')
    rate = HistoricalData::CURRENCY_RATES[currency][year][month]

    (amount * rate).ceil(2)
  end
end
