class Ema < RangeReplay
  
  attr_accessor :ema_period, :smooth
  
  def initialize(ema_period, from = Time.new(2001), till = Time.new(2002))
    quotes  = Quote.where(symbol: '^aex').where("date >= ?", from).where("date < ?", till)
    extra_quotes = 250 + ema_period
    
    self.quotes  = quotes.first.previous_quotes(extra_quotes) + quotes
    signals = StockMathRange.ema(quotes.map(&:close), ema_period)
    
    quotes.shift(extra_quotes)
    signals.pop(quotes.length)
    
    super(quotes, signals, from, till)
  end
  
  def buy?
    stocks == 0 && current_quote.close > current_signal
  end
  
  def sell?
    stocks > 0 && current_quote.close < current_signal
  end
end
