class Macd < Replay
  def initialize(from = Time.new(2001), till = Time.new(2002))
    self.from = from
    self.till = till
    super(from, till)
  end
  
  def buy?
    puts "buy: #{current_quote.macd} > #{current_quote.exponential_moving_average(9)}"
    current_quote.macd > current_quote.exponential_moving_average(9) && stocks == 0
  end
  
  def sell?
    puts "sell: #{current_quote.macd} < #{current_quote.exponential_moving_average(9)} && #{stocks} > 0"
    current_quote.macd < current_quote.exponential_moving_average(9) && stocks > 0
  end
  
end