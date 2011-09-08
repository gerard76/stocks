require 'spec_helper'

describe Quote do
  
  let(:quote) { Factory(:quote) }
  let(:prices) { [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29, 22.15, 22.39, 22.38,
                  22.61, 23.36, 24.05, 23.75, 23.83, 23.95, 23.63, 23.82, 23.87, 23.65, 23.19, 23.10,
                  23.33, 22.68, 23.10, 22.40, 22.17] }
                
  describe "validations" do
    it { should validate_presence_of(:symbol) }
    it { quote;
         should validate_uniqueness_of(:symbol).scoped_to(:date) }
  end
  
  describe "instance methods" do
    before do
      prices.each_with_index do |price, index|
        Factory(:quote, close: price, date: index.days.from_now)
      end
    end
    
    describe "#simple_moving_average" do
      it "returns 23.14 as the SMA" do
        Quote.last.simple_moving_average(10).should eql(23.13)
      end
    end
    
    describe "#exponential_moving_average" do
      it "returns 22.92 as EMA" do
        Quote.last.exponential_moving_average(10).should eql(22.92)
      end
    end
    
    describe "macd" do
      it "returns the proper macd" do
        Quote.last.macd(2, 8).should eql(-0.05)
      end
    end
  end
  
  describe "private methods" do
    describe "#select_period" do
      before do
        VCR.use_cassette('apple_quote') do
          h = HistoricalQuote.new('AAPL', 30.days.ago)
          h.fetch
          h.save_quotes
        end
        
        @quotes = Quote.last.send(:select_period, 10)
      end
      
      it "returns 10 elements" do
        @quotes.should have(10).quotes
      end
      
      it "returns last 10 quotes" do
        @quotes.last.date.strftime("%Y-%m-%d").should  eql("2011-09-07")
        @quotes.first.date.strftime("%Y-%m-%d").should eql("2011-08-24")
      end
    end
  end
end
