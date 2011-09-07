class QuoteMath
  class << self
    def exponential_moving_average(prices, period)
      return simple_moving_average(prices, period) if prices.length == period
      
      multiplier = (2.to_f / (period + 1))
      
      current = prices.pop
      previous = exponential_moving_average(prices, period)
      
      ((current - previous) * multiplier + previous).round(2)
    end
    
    def simple_moving_average(prices, period)
      (prices.sum / prices.length).round(2)
    end
  end
end