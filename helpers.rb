module Helpers
  class DateConverter
    def self.convert(value)
      Date.parse(value)
    end
  end

  class CurrencyConverter
    def self.convert(value)
      return 'usd' if usd?(value)
      return 'eur' if eur?(value)
      return 'gbp' if gbp?(value)

      return 'unknown'
    end

    class << self
      def usd?(value)
        ['$', 'USD', 'US dollars'].include?(value.strip)
      end

      def eur?(value)
        ['€', 'EUR', 'euro'].include?(value.strip)
      end

      def gbp?(value)
        ['£','GBP', 'pounds'].include?(value.strip)
      end
    end
  end

  class AmountConverter
    def self.convert(value)
      value.to_f
    end
  end
end