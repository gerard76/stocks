class SmaCrossover < Replay
  
  attr_accessor :period_long, :period_short
  
  def initialize(period_long, period_short, from = Time.new(2001), till = Time.new(2002))
    self.period_long  = period_long
    self.period_short = period_short
    
    super(from, till)
  end
  
  def buy?
    sma_long  = current_quote.simple_moving_average(period_long)
    sma_short = current_quote.simple_moving_average(period_short)
    
    sma_short > sma_long && stocks == 0
  end
  
  def sell?
    sma_long  = current_quote.simple_moving_average(period_long)
    sma_short = current_quote.simple_moving_average(period_short)
    
    sma_short < sma_long && stocks > 0
  end
end