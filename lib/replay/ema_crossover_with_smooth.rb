class EmaCrossoverWithSmooth < RangeReplay
  
  attr_accessor :fast, :slow, :smooth
  
  def initialize(fast, slow, smooth, from = Time.new(2001), till = Time.new(2001))
    q = Quote.where(symbol: '^aex').where("date >= ?", from).where("date < ?", till)
    extra_quotes = 250 + slow
    
    self.quotes  = q.first.previous_quotes(extra_quotes) + q
    
    fast_signals = StockMathRange.ema(quotes.map(&:close), fast).pop(q.length)
    slow_signals = StockMathRange.ema(quotes.map(&:close), slow).pop(q.length)
    
    signals = []
    q.length.times do |index|
      signals << [fast_signals[index], slow_signals[index]]
    end
    
    self.smooth = smooth
    
    super(quotes.pop(q.length), signals, from, till)
  end
  
  def buy?
    ema_fast = current_signal[0]
    ema_slow = current_signal[1]
    
    if stocks == 0
      buy = ema_slow < ema_fast && (ema_fast - ema_slow) > (smooth * 2 * current_quote.close)
      puts "#{ema_slow} < #{ema_fast} && (#{ema_fast} - #{ema_slow}) > (#{smooth} * 2 * #{current_quote.close})" if buy
      buy
    end
  end
  
  def sell?
    ema_fast = current_signal[0]
    ema_slow = current_signal[1]
    
    if stocks > 0
      sell = ema_slow > ema_fast && (ema_slow - ema_fast) > (smooth/2 * current_quote.close)
      puts "#{ema_slow} > #{ema_fast} && (#{ema_slow} - #{ema_fast}) > (#{smooth} * #{current_quote.close})" if sell
      sell
    end
  end
end