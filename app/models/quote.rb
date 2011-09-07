class Quote < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  ### VALIDATIONS:
  validates :symbol, presence: true, uniqueness: { scope: :date }
  
  ### SCOPES:
  default_scope :order => "date ASC"
  
  scope :symbols, select(:symbol).group(:symbol)
  
  scope :year, lambda { |year| where("YEAR(date) = #{year}") }
  
  ### INSTANCE METHODS
  def simple_moving_average(period)
    StockMath.simple_moving_average(select_period(period)[:close], period)
  end
  memoize :simple_moving_average
  
  def exponential_moving_average(period)
    StockMath.exponential_moving_average(select_period(100 + period)[:close], period)
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
    
  def select_period(period)
    Quote.where(symbol: symbol).where("date <= ? AND date > ?", date, date - period.days)
  end
end
