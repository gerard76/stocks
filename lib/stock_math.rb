class StockMath
  class << self
    def exponential_moving_average(prices, period)
      return simple_moving_average(prices, period) if prices.length <= period
      
      multiplier = (2.to_f / (period + 1))
      
      new_prices = prices.dup
      current    = new_prices.pop
      previous   = exponential_moving_average(new_prices, period)
      
      ((current - previous) * multiplier + previous).round(2)
    end
    alias :ema :exponential_moving_average
    
    def simple_moving_average(prices, period)
      (prices.sum / prices.length).round(2)
    end
    alias :sma :simple_moving_average
    
    
    def macd(prices, short = 12, long = 26)
      (exponential_moving_average(prices, short) - exponential_moving_average(prices, long)).round(2)
    end
  end
end