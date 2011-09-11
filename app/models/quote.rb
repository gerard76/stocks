class Quote < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  
  ### VALIDATIONS:
  validates :symbol, presence: true, uniqueness: { scope: :date }
  
  ### SCOPES:
  default_scope :order => "date ASC"
  
  scope :symbols, select(:symbol).group(:symbol)
  
  scope :year, lambda { |year| where("YEAR(date) = #{year}") }
  
  ### INSTANCE METHODS:
  
  def update_data
    h = HistoricalQuote.new(symbol, Quote.last.date)
    h.fetch
    h.save_quotes
  end
  
  def simple_moving_average(period)
    StockMath.simple_moving_average(previous_prices(period), period)
  end
  memoize :simple_moving_average
  alias :sma :simple_moving_average
  
  def exponential_moving_average(period)
    StockMath.exponential_moving_average(previous_prices(5 * period), period)
  end
  memoize :exponential_moving_average
  alias :ema :exponential_moving_average
  
  def macd(short = 12, long = 26)
    StockMath.macd(previous_prices(long + 100), short, long)
  end
  
  def previous_prices(period)
    count = Quote.where(symbol: symbol).where("date <= ?", date).count
    if count < period
      raise "Not enough quotes for calculation! #{period} needed, got #{count}"
    end
    
    Quote.unscoped.where(symbol: symbol).where("date <= ?", date).limit(period).order("date DESC")[:close].reverse
  end
  
  def previous_quotes(period)
    Quote.unscoped.where(symbol: symbol).where("date <= ?", date).limit(period).order("date DESC").reverse
  end
end
