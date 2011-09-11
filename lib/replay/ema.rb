class Ema < Replay
  
  attr_accessor :ema_period, :smooth
  
  def initialize(ema_period, smooth,from = Time.new(2001), till = Time.new(2002))
    self.ema_period = ema_period
    self.smooth = smooth
    super(from, till)
  end
  
  def buy?
    ema = current_quote.ema(ema_period) * (1 + smooth)
    stocks == 0 && current_quote.close > ema
  end
  
  def sell?
    ema = current_quote.ema(ema_period) * (1 - smooth)
    stocks > 0 && current_quote.close < ema
  end
end
