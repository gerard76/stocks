class Sma < Replay
  
  attr_accessor :sma_period
  
  def initialize(sma_period, from = Time.new(2001), till = Time.new(2002))
    self.sma_period = sma_period
    super(from, till)
  end
  
  def buy?
    current_quote.close > current_quote.simple_moving_average(sma_period) && stocks == 0
  end
  
  def sell?
    current_quote.close < current_quote.simple_moving_average(sma_period) && stocks > 0
  end
end