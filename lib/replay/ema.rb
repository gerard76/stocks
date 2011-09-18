class Ema < RangeReplay
  
  attr_accessor :ema_period, :smooth
  
  def initialize(ema_period, from = Time.new(2001), till = Time.new(2002))
    q = Quote.where(symbol: '^aex').where("date >= ?", from).where("date < ?", till)
    extra_quotes = 250 + ema_period
    # q.each { |s| puts [s.date, s.close.to_f.round(2)] }
    
    self.quotes  = q.first.previous_quotes(extra_quotes) + q
    
    
    self.signals = StockMathRange.ema(self.quotes.map(&:close), ema_period).pop(q.length)
    
    self.quotes.shift(extra_quotes)
    
    # puts signals.inspect
    # quotes.each_with_index { |q, index| puts [q.date, signals[index]].inspect }
    
    super(quotes, signals, from, till)
  end
  
  def buy?
    stocks == 0 && current_quote.close > current_signal
  end
  
  def sell?
    stocks > 0 && current_quote.close < current_signal
  end
end
