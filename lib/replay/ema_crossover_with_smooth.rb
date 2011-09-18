class EmaCrossoverWithSmooth < RangeReplay
  
  attr_accessor :fast, :slow, :smooth
  
  def initialize(fast, slow, smooth, from = Time.new(2001), till = Time.new(2001))
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
    ema_fast = current_signal[0]
    ema_slow = current_signal[1]
    
    # only buy when the ema's cross and we're going up
    ema_slow < ema_fast && (ema_fast - ema_slow) > (smooth * 2 * current_quote.close) && stocks == 0
  end
  
  def sell?
    ema_fast = current_signal[0]
    ema_slow = current_signal[1]
    
    ema_slow > ema_fast && (ema_slow - ema_fast) > (smooth * current_quote.close) && stocks > 0
  end
end