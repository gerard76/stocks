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
    
    uptrend = sma_fast > current_quote.previous_quotes(2).first.sma(fast) &&
                sma_slow > current_quote.previous_quotes(2).first.sma(slow)
                
    # only buy when the sma's cross and we're going up
    (sma_fast - sma_slow) > (smooth * current_quote.close) && stocks == 0
  end
  
  def sell?
    sma_fast   = current_quote.sma(fast)
    sma_slow   = current_quote.sma(slow)
    
    downtrend = sma_fast < current_quote.previous_quotes(2).first.sma(fast) &&
                 sma_slow < current_quote.previous_quotes(2).first.sma(slow)
    
    # sell fast if we're going down and the sma's cross
    if downtrend
      (sma_fast < sma_slow) && stocks > 0
    else
      # wait a little to see what it does before selling
      (sma_slow - sma_fast) > (smooth * current_quote.close) && stocks > 0
    end
  end
end