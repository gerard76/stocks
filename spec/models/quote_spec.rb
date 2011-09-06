require 'spec_helper'

describe Quote do
  
  let(:quote) { Quote.new('GOOG') }
  
  describe "validations" do
    it { should validate_presence_of(:symbol) }
    it { quote;
         should validate_uniqueness_of(:symbol).scoped_to(:trade_time) }
  end
  
  describe "instance methods" do
    describe "#change" do
      it "returns the change between last trade price and previous close" do
        quote.trade_price = 520.04
        quote.previous_close   = 523.29
        
        quote.change.should eql(-3.25)
      end
    end
    
    describe "#change_in_percent" do
      it "returns the change in percent between the previous close and last trade price" do
        quote.trade_price = 520.04
        quote.previous_close   = 523.29
        
        quote.change_in_percent.should eql(-0.62)
      end
    end
    
    describe "#trade_date" do
      it "returns the date portion of the trade time" do
        quote.trade_time = DateTime.new(2010, 2, 13)
        
        quote.trade_date.to_s.should eql("2010-02-13")
      end
    end
    
    describe "moving averages" do
      before(:each) do
        [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29].each_with_index do |close, index|
          Factory(:quote, close: close, date: index.days.from_now)
        end
        
        @quote = Quote.last
      end
      
      describe "#simple_moving_average" do
        it "returns the proper simple moving average" do
         raise Quote.all.map(&:close).inspect
          @quote.simple_moving_average(10).round(2).to_f.should eql(22.22)
        end
      end
      
      describe "#exponential_moving_average" do
        it "returns the proper EMA" do
          @quote.exponential_moving_average(10).round(2).to_f.should eql(22.22)
        end
      end
    end
  end
end
