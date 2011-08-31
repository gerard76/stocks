cash = 100000
stocks = 0
value = 0
(1993..1993).each do |year|
  
  Quote.year(1994).each do |quote|
    if (quote.close > quote.simple_moving_average(quote.best_ma_period(100))) && stocks == 0
      stocks = (cash / quote.close).to_i
      cash  -= (stocks * quote.close)
    elsif (quote.close < quote.simple_moving_average(quote.best_ma_period(100))) && stocks > 0
      cash += stocks * quote.close
      stocks = 0
    end
    
    value = cash + stocks * quote.close
  end
  puts "value: #{value}"
end

