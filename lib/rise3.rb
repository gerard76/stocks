# compare different SMA periods

max_value, max_period = 0, 0
(5..50).each do |period|
  stocks, value = 0, 0
  cash = 100000
  Quote.year(1994).each do |quote|
    if quote.close > quote.simple_moving_average(period) && stocks == 0
      stocks = (cash / quote.close).to_i
      cash  -= (stocks * quote.close)
    elsif quote.close < quote.simple_moving_average(period) && stocks > 0
      cash += stocks * quote.close
      stocks = 0
    end
    
    value = cash + stocks * quote.close
  end
  puts "period: #{period} value: #{value}"
  if value > max_value
    max_value  = value
    max_period = period
  end
end
puts "best period for SMA: #{max_period} with #{max_value}"

# compare different EMA periods
max_value, max_period = 0, 0
(5..50).each do |period|
  stocks, value = 0, 0
  cash = 100000
  Quote.year(1994).each do |quote|
    if quote.close > quote.exponential_moving_average(period) && stocks == 0
      stocks = (cash / quote.close).to_i
      cash  -= (stocks * quote.close)
    elsif quote.close < quote.exponential_moving_average(period) && stocks > 0
      cash += stocks * quote.close
      stocks = 0
    end
    
    value = cash + stocks * quote.close
  end
  puts "period: #{period} value: #{value}"
  if value > max_value
    max_value  = value
    max_period = period
  end
end
puts "best period for EMA: #{max_period} with #{max_value}"

# guess future best SMA period by looking at the past 10 days
max_value, max_period = 0, 0
stocks, value = 0, 0
cash = 100000
Quote.year(1994).each do |quote|
  if quote.close > quote.simple_moving_average(quote.best_sma_period(10)) && stocks == 0
    stocks = (cash / quote.close).to_i
    cash  -= (stocks * quote.close)
  elsif quote.close < quote.simple_moving_average(quote.best_sma_period(10)) && stocks > 0
    cash += stocks * quote.close
    stocks = 0
  end
  
  value = cash + stocks * quote.close
end
puts "value: #{value}"

# guess future best EMA period by looking at the past 10 days
max_value, max_period = 0, 0
stocks, value = 0, 0
cash = 100000
Quote.year(1994).each do |quote|
  if quote.close > quote.simple_moving_average(quote.best_ema_period(10)) && stocks == 0
    stocks = (cash / quote.close).to_i
    cash  -= (stocks * quote.close)
  elsif quote.close < quote.simple_moving_average(quote.best_ema_period(10)) && stocks > 0
    cash += stocks * quote.close
    stocks = 0
  end
  
  value = cash + stocks * quote.close
end
puts "value: #{value}"