class Ema < Replay
  
  attr_accessor :ema_period
  
  def initialize(ema_period, from = Time.new(2001), till = Time.new(2002))
    self.ema_period = ema_period
    super(from, till)
  end
  
  def buy?
    current_quote.close > current_quote.exponential_moving_average(ema_period) && stocks == 0
  end
  
  def sell?
    current_quote.close < current_quote.exponential_moving_average(ema_period) && stocks > 0
  end
end
