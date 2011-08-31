class Quote < ActiveRecord::Base

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
    previous_quotes(period)[:close].mean
  end
  
  def exponential_moving_average(period, attribute = :close)
    multiplier = (2.to_f / period + 1)
    
    (close - yesterday.exponential_moving_average) * multiplier + yesterday.exponential_moving_average
    
    previous_quotes(period).map(&attribute)
  def best_ma_period(look_back_period, range_from = 5, range_to = 50)
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
  
  private
  
  def previous_quotes(period)
    Quote.where(symbol: symbol).where("date < ? AND date >= ?", date, date - period.days)
  end
  
  def yesterday
    previous_quotes(1).first
  end
end
