require 'csv'

class SlimQuote
  PROPERTIES = {
    symbol:                     's',
    name:                       'n',
    last_trade_price_only:      'l1',
    last_trade_date:            'd1',
    last_trade_time:            't1',
    change_with_percent_change: 'c',
    change:                     'c1',
    previous_close:             'p',
    change_in_percent:          'p2',
    open:                       'o',
    day_low:                    'g',
    day_high:                   'h',
    volume:                     'v',
    last_trade_with_time:       'l',
    day_range:                  'm',
    ticker_trend:               't7',
    ask:                        'a',
    average_daily_volume:       'a2',
    bid:                        'b',
    bid_size:                   'b4'
  }
  
  attr_accessor :symbol, :properties, :values
  
  def initialize(symbol, properties = [])
    self.symbol     = symbol
    self.properties = properties
    self.values     = {}
  end
  
  def fetch
    parse_result(Net::HTTP.get(URI.parse(fetch_url)))
  end
  alias :refresh :fetch
  
  private
  
  def fetch_url
    "http://download.finance.yahoo.com/d/quotes.csv?s=#{symbol_for_url}&f=#{properties_for_url}&e=.csv"
  end
  
  def symbol_for_url
    symbol.match(/%/) ? symbol : CGI::escape(symbol)
  end
  
  def properties_for_url
    active_properties.map { |active_property| PROPERTIES[active_property] }.join
  end
  
  def active_properties
    if properties.blank?
      PROPERTIES.keys
    else
      properties.select { |property| PROPERTIES.keys.include?(property)}
    end
  end
  
  def parse_result(result)
    CSV.parse(result)[0].each_with_index do |value, index|
      self.values[active_properties[index]] = value
    end
  end
end
