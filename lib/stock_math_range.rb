class StockMathRange
  class << self
    def ema(data, period)
      emas = [calculate_sma(data, period)]
      data.slice(period..-1).each { |current| emas << calculate_ema(emas.last, current, period) }
      
      emas
    end
    
    def sma(data, period)
      smas = []
      (data.length - period).times do |index|
        smas << calculate_sma(data.slice(index, period), period)
      end
      
      smas
    end
    
    def calculate_ema(previous, current, period)
      ((current - previous) * (2.0 / (period + 1)) + previous).round(2)
    end
    
    def calculate_sma(data, period)
      (data.pop(period).sum / period).to_f.round(2)
    end
  end
end