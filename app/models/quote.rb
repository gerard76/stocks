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
  
  def simple_moving_average(period, attribute = :close)
    previous_quotes(period).map(&attribute).mean
  end
  
  def exponential_moving_average(period, attribute = :close)
    multiplier = (2.to_f / period + 1)
    
    (close - yesterday.exponential_moving_average) * multiplier + yesterday.exponential_moving_average
    
    previous_quotes(period).map(&attribute)
  end
  
  private
  
  def previous_quotes(period)
    Quote.where(symbol: symbol).where("date < ? AND date >= ?", date, date - period.days)
  end
  
  def yesterday
    previous_quotes(1).first
  end
end
