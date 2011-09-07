class Quote < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  ### VALIDATIONS:
  validates :symbol, presence: true, uniqueness: { scope: :date }
  
  ### SCOPES:
  default_scope :order => "date ASC"
  
  scope :symbols, select(:symbol).group(:symbol)
  
  scope :year, lambda { |year| where("YEAR(date) = #{year}") }
  
  ### INSTANCE METHODS
  def change
    trade_price - previous_close
  end
  
  def change_in_percent
    (change / previous_close * 100).round(2)
  end
  
  def simple_moving_average(period)
    previous_quotes(period)[:close].map(&:to_f).mean
    select_period(period)[:close].map(&:to_f).map { |q| q.round(2) }.mean.round(2)
  end
  memoize :simple_moving_average
  
  def exponential_moving_average(period)
    calculate_exponential_moving_average(select_period(100 + period)[:close], period)
  end
  memoize :exponential_moving_average
  
  def best_sma_period(look_back_period, range_from = 5, range_to = 50)
    max_value, max_period = 0, 0
    previous = previous_quotes(look_back_period)
    (range_from..range_to).each do |period|
      stocks, value, cash = 0, 0, 10000
      previous.each do |quote|
        if (quote.close > quote.simple_moving_average(period)) && stocks == 0
          stocks = (cash / quote.close).to_i
          cash  -= (stocks * quote.close)
        elsif (quote.close < quote.simple_moving_average(period)) && stocks > 0
          cash += stocks * quote.close
          stocks = 0
        end
      end
      value = cash + stocks * self.close
      if value > max_value
        max_value  = value
        max_period = period
      end
    end
    puts "best period: #{max_period}"
    max_period
  end
  memoize :best_sma_period
  
  def best_ema_period(look_back_period, range_from = 5, range_to = 50)
    max_value, max_period = 0, 0
    previous = previous_quotes(look_back_period)
    (range_from..range_to).each do |period|
      stocks, value, cash = 0, 0, 10000
      previous.each do |quote|
        if (quote.close > quote.exponential_moving_average(period)) && stocks == 0
          stocks = (cash / quote.close).to_i
          cash  -= (stocks * quote.close)
        elsif (quote.close < quote.exponential_moving_average(period)) && stocks > 0
          cash += stocks * quote.close
          stocks = 0
        end
      end
      value = cash + stocks * self.close
      if value > max_value
        max_value  = value
        max_period = period
      end
    end
    puts "best period: #{max_period}"
    max_period
  end
  memoize :best_ema_period
  
  private
  
  def calculate_exponential_moving_average(quotes, period)
    return quotes.mean.round(2) if quotes.length == period
    
    multiplier = (2.to_f / period + 1)
    puts "#{quotes.map(&:to_f).inspect} - #{multiplier.to_f}"
    close = quotes.pop
    previous = calculate_exponential_moving_average(quotes, period)
    
    (close - previous) * multiplier + previous
    # quotes.pop * multiplier +  * (1 - multiplier)
  end
    
  def select_period(period)
    Quote.where(symbol: symbol).where("date <= ? AND date > ?", date, date - period.days)
  end
  
  def yesterday
    previous_quotes(1).first
  end
end
