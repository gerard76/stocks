class SmaCrossoverWithSmooth < Replay
  
  attr_accessor :fast, :medium, :slow, :smooth
  
  def initialize(fast, slow, smooth, from = Time.new(2001), till = Time.new(2001))
    self.fast   = fast
    self.slow   = slow
    self.smooth = smooth
    
    super(from, till)
  end
  
  def buy?
    sma_fast   = current_quote.sma(fast)
    sma_slow   = current_quote.sma(slow)
    # puts "diff: #{sma_fast - sma_slow} > #{(smooth * current_quote.close)}"
    (sma_fast - sma_slow) > (smooth * current_quote.close) && stocks == 0
  end
  
  def sell?
    sma_fast   = current_quote.sma(fast)
    sma_slow   = current_quote.sma(slow)
    
    # sma_fast < sma_slow && stocks > 0
    (sma_slow - sma_fast) > ((smooth/2) * current_quote.close) && stocks > 0
  end
end