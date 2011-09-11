class EmaCrossoverWithSmooth < Replay
  
  attr_accessor :fast, :medium, :slow, :smooth
  
  def initialize(fast, slow, smooth, from = Time.new(2001), till = Time.new(2001))
    self.fast   = fast
    self.slow   = slow
    self.smooth = smooth
    
    super(from, till)
  end
  
  def buy?
    ema_fast   = current_quote.ema(fast)
    ema_slow   = current_quote.ema(slow)
    # puts "diff: #{ema_fast - ema_slow} > #{(smooth * current_quote.close)}"
    (ema_fast - ema_slow) > (smooth * current_quote.close) && stocks == 0
  end
  
  def sell?
    ema_fast   = current_quote.ema(fast)
    ema_slow   = current_quote.ema(slow)
    
    # ema_fast < ema_slow && stocks > 0
    (ema_slow - ema_fast) > (smooth * current_quote.close) && stocks > 0
  end
end