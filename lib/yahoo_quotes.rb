class YahooQuotes < YahooQuote
  
  attr_accessor :symbols, :properties, :values
   
  def initialize(symbols, properties = [])
    super
    self.symbols    = symbols
    self.values     = []
  end
  
  private
  
  def parse_result(result)
    CSV.parse(result).each do |quote|
      hash = {}
      quote.each_with_index do |value, index|
        hash[active_properties[index]] = value
      end
      self.values << hash unless hash.blank?
    end
  end
end