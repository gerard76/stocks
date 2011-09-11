class Macd < Replay
  def initialize(from = Time.new(2001), till = Time.new(2002))
    self.from = from
    self.till = till
    super(from, till)
  end
  
  def buy?
    macds = []
    current_quote.previous_quotes(9).each do |quote|
      macds << quote.macd
    end
    # moet ema(9) van macd hebben, gebruik maar even sma
    # puts "buy: #{current_quote.macd} > #{current_quote.exponential_moving_average(9)}"
    # current_quote.macd > current_quote.exponential_moving_average(9) && stocks == 0
    stocks == 0 && current_quote.macd > StockMath.sma(macds)
    
  end
  
  def sell?
    macds = []
    current_quote.previous_quotes(9).each do |quote|
      macds << quote.macd
    end
    # puts "sell: #{current_quote.macd} < #{current_quote.exponential_moving_average(9)} && #{stocks} > 0"
    # current_quote.macd < current_quote.exponential_moving_average(9) && stocks > 0
    stocks > 0 && current_quote.macd < StockMath.sma(macds)
  end
end