cash = 100000
stocks = 0
(1993..2011).each do |year|
  puts "****"
  puts "YEAR #{year}"
  puts "****"
  value = 0
  max_value, min_value   = 0, 0
  max_period, min_period = 0, 0
  period = 20
  # (5..50).each do |period|
    # stocks, max_year_value, min_year_value = 0, 0, 0
    
    Quote.year(year).each do |quote|
      if (quote.close > quote.simple_moving_average(period)) && stocks == 0
        # buy
        stocks = (cash / quote.close).to_i
        cash  -= (stocks * quote.close)
        # puts "buy #{stocks} stocks for #{quote.close}. cash: #{cash}"
      elsif (quote.close < quote.simple_moving_average(period)) && stocks > 0
        # sell
        cash += stocks * quote.close
        # puts "sell #{stocks} stocks for #{quote.close}. cash: #{cash}"
        stocks = 0
      end
      
      value = cash + stocks * quote.close
      # max_year_value = value if value > max_year_value
     # min_year_value = value if value < min_year_value || min_year_value == 0
    end;false
    
    # puts "sma_period: #{period} min: #{min_year_value}, max: #{max_year_value}, result: #{value}"
    
    # if max_year_value > max_value
    #   max_value  = max_year_value
    #   max_period = period
    # end
    # 
    # if min_year_value < min_value || min_value == 0
    #   min_value  = min_year_value
    #   min_period = period
    # end
  # end
  puts "cash: #{cash} value: #{value}"
  # puts "year: #{year}  Best period: #{max_period} with max_value: #{max_value}  and min_value: #{min_value} with sma period: #{min_period}"
  
end

puts "result: #{cash} stocks: #{stocks} close: #{Quote.last.close} max: #{max_cash}"

