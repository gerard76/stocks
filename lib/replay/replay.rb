class Replay
  INITITAL_CASH = 10000
  
  attr_accessor :stocks, :cash, :from, :till, :current_quote
  
  # stats
  attr_accessor :buy_count, :sell_count, :max, :min, :last_buy_price
  
  def initialize(from, till)
    self.cash   = INITITAL_CASH
    self.stocks = 0
    self.from   = from
    self.till   = till
    
    # stats
    self.buy_count, self.sell_count = 0, 0
    self.max, self.min = {}, {}
    self.max[:value], self.min[:value]   = INITITAL_CASH, INITITAL_CASH
    self.max[:profit], self.min[:profit] = 0, 0
  end
  
  def self.run(*options)
    new(*options).run
  end
  
  def run
    (from.year..till.year).each do |year|
      Quote.year(year).each do |quote|
        self.current_quote = quote
        if buy?
          buy
        elsif sell?
          sell
        end
      end
    end
    
    result
  end
  
  def buy?
    raise "implement buy strategy"
  end
  
  def sell?
    raise "implement sell strategy"
  end
  
  def buy
    self.stocks = (cash / current_quote.close).to_i
    self.cash  -= (stocks * current_quote.close)
    self.buy_count += 1
    # puts "on #{current_quote.date} buy #{stocks} for #{current_quote.close} - value: #{value}"
    store_statistics
    self.last_buy_price = current_quote.close
  end
  
  def sell
    # puts "on #{current_quote.date} sell #{stocks} for #{current_quote.close} - value: #{value}"
    self.cash += stocks * current_quote.close
    self.stocks = 0
    self.sell_count += 1
    store_statistics
  end
  
  def result
    puts "#### RESULT ####"
    puts "started with #{INITITAL_CASH} and was left with #{value} - profit: #{profit_in_percent}% (#{profit_per_year_in_percent}% per year)"
    puts "#{buy_count} buy operations and #{sell_count} sell operations (#{operations_per_year} operations per year)"
    puts "max value: #{max[:value]} (#{max[:profit]}%) - min value: #{min[:value]} (#{min[:profit]}%)"
  end
  
  private
  
  def store_statistics
    if value > max[:value]
      self.max[:value]  = value
      self.max[:profit] = profit_in_percent
    elsif value < min[:value]
      self.min[:value]  = value
      self.min[:profit] = profit_in_percent
    end
  end
  
  def value
    cash + stocks * current_quote.close
  end
  
  def profit_in_percent
    ((value - INITITAL_CASH) / INITITAL_CASH * 100).round(2)
  end
  
  def profit_per_year_in_percent
    (profit_in_percent / years_run).round(2)
  end
  
  def operations_per_year
    ((buy_count + sell_count) / years_run).round
  end
  
  def years_run
    till.year - from.year + 1
  end
end