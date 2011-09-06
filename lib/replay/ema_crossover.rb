class EmaCrossover < Replay
  
  attr_accessor :fast, :medium, :slow
  
  def initialize(fast, slow, from = Time.new(2001), till = Time.new(2002))
    self.fast   = fast
    self.slow   = slow
    
    super(from, till)
  end
  
  def buy?
    ema_fast   = current_quote.exponential_moving_average(fast)
    ema_slow   = current_quote.exponential_moving_average(slow)
    
    ema_fast > ema_slow && stocks == 0
  end
  
  def sell?
    ema_fast   = current_quote.exponential_moving_average(fast)
    ema_slow   = current_quote.exponential_moving_average(slow)
    
    ema_fast < ema_slow && stocks > 0
  end
end