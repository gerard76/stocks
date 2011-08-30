require 'csv'

class XQuote
  PROPERTIES = [
    { name: :symbol,                     short: 's',  klass: String  },
    { name: :name,                       short: 'n',  klass: String  },
    { name: :last_trade_price_only,      short: 'l1', klass: Float   },
    { name: :last_trade_date,            short: 'd1', klass: Date    },
    { name: :last_trade_time,            short: 't1', klass: Time    },
    { name: :change_with_percent_change, short: 'c',  klass: String  },
    { name: :change,                     short: 'c1', klass: Float   },
    { name: :previous_close,             short: 'p',  klass: Float   },
    { name: :change_in_percent,          short: 'p2', klass: Float   },
    { name: :open,                       short: 'o',  klass: Float   },
    { name: :day_low,                    short: 'g',  klass: Float   },
    { name: :day_high,                   short: 'h',  klass: Float   },
    { name: :volume,                     short: 'v',  klass: Integer },
    { name: :last_trade_with_time,       short: 'l',  klass: String  },
    { name: :day_range,                  short: 'm',  klass: Range   },
    { name: :ticker_trend,               short: 't7', klass: String  },
    { name: :ask,                        short: 'a',  klass: Float   },
    { name: :average_daily_volume,       short: 'a2', klass: Integer },
    { name: :bid,                        short: 'b',  klass: Float   },
    { name: :bid_size,                   short: 'b4', klass: Float   }
  ]
  
  PROPERTIES.each { |p| attr_accessor p[:name] }
  
  def initialize(symbol)
    self.symbol = symbol
  end
  
  def fetch
    parse_result(Net::HTTP.get(URI.parse(fetch_url)))
  end
  alias :refresh :fetch
  
  private
  
  def fetch_url
    "http://download.finance.yahoo.com/d/quotes.csv?s=#{symbol_for_url}&f=#{PROPERTIES.map { |p| p[:short] }.join}&e=.csv"
  end
  
  def symbol_for_url
    symbol.match(/%/) ? symbol : CGI::escape(symbol)
  end
  
  def parse_result(result)
    CSV.parse(result)[0].each_with_index do |value, index|
      cast_value = 
        case PROPERTIES[index][:klass].to_s
        when 'Float'
         value.to_f
        when 'Integer'
         value.to_i
        when 'Range'
         if value =~ /N\/A/
           nil
         else
           split = value.split(' - ')
           Range.new(split[0], split[1])
         end
        when 'Date', 'Time'
         Chronic.parse(value)
        when 'String'
         value
        end
      self.send("#{PROPERTIES[index][:name]}=", cast_value)
    end
  end
end
