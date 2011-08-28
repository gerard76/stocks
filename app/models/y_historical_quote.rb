require 'csv'
class YHistoricalQuote
  
  attr_accessor :symbol, :from_date, :to_date, :interval, :quotes
  
  def initialize(symbol, from_date, to_date, interval = :weekly)
    self.symbol    = symbol
    self.from_date = from_date
    self.to_date   = to_date
    self.interval  = interval
    self.quotes    = []
  end
  
  def fetch
    parse_result(Net::HTTP.get(URI.parse(fetch_url)))
    self
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
    self.quotes = []
    CSV.parse(result, headers: true).each do |line|
      y_quote = YQuote.new(symbol: symbol)
      y_quote.values[:date]           = Chronic.parse(line[0])
      y_quote.values[:open]           = line[1]
      y_quote.values[:high]           = line[2]
      y_quote.values[:low]            = line[3]
      y_quote.values[:close]          = line[4]
      y_quote.values[:volume]         = line[5]
      y_quote.values[:adjusted_close] = line[6]
        
      self.quotes << y_quote
    end
  end
end