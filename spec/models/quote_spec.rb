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
  end
end
