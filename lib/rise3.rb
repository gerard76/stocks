class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end
  
  def mean 
    sum / size
  end
end
smas = {}
(1992..2011).each do |year|
  quotes = []
  portfolio = 0
  stocks = 0
  max_cash = 0
  value = 0 
  max_value = 0
  max_period = 0
  smas[year] = []
  (2..500).each do |period|
    quotes = []
    portfolio = 0
    cash = 100000
    stocks = 0
    max_cash = 0
    Quote.year(year).each do |quote|
      quotes.shift
      quotes[period - 1] = quote.close
      
      if quotes.compact.length == period
        sma = quotes.mean
        if quotes[period - 1] > sma && stocks == 0
          # buy
          stocks = (cash / quote.close).to_i
          cash -= stocks * quote.close
          # puts "buy #{(cash / quote.close).to_i} stocks for #{quote.close}. cash: #{cash}"
        elsif quotes[period - 1] < sma && stocks > 0
          # sell
          cash += stocks * quote.close
          # puts "sell #{stocks} stocks for #{quote.close}. cash: #{cash}"
          stocks = 0
        end
      
        max_cash = cash if cash > max_cash
      end
      value = cash + stocks * quote.close
    end
    if value >= max_value
      max_value = value
      max_period = period
      smas[year] << [period, value.to_i]
    end
  end
  puts "year: #{year} value: #{max_value} sma period: #{max_period}"
end
# puts "result: #{cash} stocks: #{stocks} close: #{Quote.last.close} max: #{max_cash}"

