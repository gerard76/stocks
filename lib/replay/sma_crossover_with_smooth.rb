class SmaCrossoverWithSmooth < RangeReplay
  
  attr_accessor :fast, :medium, :slow, :smooth
  
  def initialize(fast, slow, smooth, from = Time.new(2001), till = Time.new(2002))
    
    q = Quote.where(symbol: '^aex').where("date >= ?", from).where("date < ?", till)
    quotes_length = q.length
    
    self.quotes  = q.first.previous_quotes(slow) + q
    
    fast_signals = StockMathRange.sma(quotes.map(&:close), fast)
    slow_signals = StockMathRange.sma(quotes.map(&:close), slow)
    
    signals = []
    quotes_length.times do |index|
      signals << [fast_signals[index], slow_signals[index]]
    end
    
    self.smooth = smooth
    
    super(quotes.pop(quotes_length), signals, from, till)
  end
  
  def buy?
    # sma_fast   = current_signal[0]
    # sma_slow   = current_signal[1]
    # previous_quote = current_quote.previous_quotes(2).first
    
    # uptrend = current_signal[0] > previous_quote.sma(fast) && sma_slow > previous_quote.sma(slow)
                
    # only buy when the sma's cross and we're going up
    (current_signal[0] - current_signal[1]) > (smooth * current_quote.close) && stocks == 0
  end
  
  def sell?
    # downtrend = current_signal[0] < current_quote.previous_quotes(2).first.sma(fast) &&
    #              current_signal[1] < current_quote.previous_quotes(2).first.sma(slow)
    
    # sell fast if we're going down and the sma's cross
    # if downtrend
      # (sma_slow - sma_fast) > ((smooth / 2) * current_quote.close)  && stocks > 0
    # else
      # wait a little to see what it does before selling
      (current_signal[1] - current_signal[0]) > (smooth * current_quote.close) && stocks > 0
    # end
  end
end