require 'csv'
class HistoricalQuote
  
  attr_accessor :symbol, :from_date, :to_date, :interval, :values
  
  def initialize(symbol, from_date, to_date, interval = :weekly)
    self.symbol    = symbol
    self.from_date = from_date
    self.to_date   = to_date
    self.interval  = interval
    self.values    = []
  end
  
  def fetch
    parse_result(Net::HTTP.get(URI.parse(fetch_url)))
  end
  
  private
  
  def fetch_url
    "http://ichart.yahoo.com/table.csv?s=#{symbol_for_url}&g=#{interval.to_s[0]}&ignore=.csv" +
      "&a=#{from_date.month - 1}&b=#{from_date.day}&c=#{from_date.year}" +
      "&d=#{to_date.month - 1}&e=#{to_date.day}&f=#{to_date.year}"
  end
 
  def symbol_for_url
    symbol.match(/%/) ? symbol : CGI::escape(symbol)
  end
  
  def parse_result(result)
    # zou ik een (base) quote terug moeten geven?
    self.values = []
    CSV.parse(result).each do |line|
      self.values <<
        { date:  Chronic.parse(line[0]),
          open:           line[1],
          high:           line[2],
          low:            line[3],
          close:          line[4],
          volume:         line[5],
          adjusted_close: line[6]
        }
    end
  end
end