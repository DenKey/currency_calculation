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
      date = record[:processed_at].year

      hash[country_code] ||= {}
      hash[country_code][date] ||= 0
      hash[country_code][date] +=  calculate_inflation(date.to_s, currency_correlation(record))
    end
  end

  private

  def calculate_inflation(from_year, amount, to_year = 2022)
    return amount if amount.zero?
   (amount * HistoricalData::US_INFLATION.fetch(to_year.to_s) / HistoricalData::US_INFLATION.fetch(from_year.to_s)).ceil(2)
  end

  def currency_correlation(record)
    amount = record[:amount].to_f
    currency = record[:currency]
    return amount if record[:currency] == USD

    year = record[:processed_at].year.to_s
    month = record[:processed_at].strftime('%b')
    rate = HistoricalData::CURRENCY_RATES[currency][year][month]
    return (amount * rate).ceil(2)
    return 0
  end
end
