max_result = ""
max_slow, max_fast = 0, 0
max_value = 0

(1..400).each do |slow|
  (1..200).each do |fast|
    puts "fast: #{fast} - slow: #{slow}"
    e = EmaCrossover.new(fast, slow, Time.new(2007), Time.new(2010))
    e.run
    if e.send(:value) > max_value
      max_value = e.send(:value)
      max_slow = slow
      max_fast = fast
      max_result = e.result
    end
  end
end

puts max_result
puts "fast: #{max_fast} slow: #{max_slow}"
