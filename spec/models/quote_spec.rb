require 'spec_helper'

describe Quote do
  
  let(:quote) { Factory(:quote) }
  
  describe "validations" do
    it { should validate_presence_of(:symbol) }
    it { quote;
         should validate_uniqueness_of(:symbol).scoped_to(:date) }
  end
  
  describe "instance methods" do
    describe "moving averages" do
      before(:each) do
        @closes = [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29]
        @closes.each_with_index do |close, index|
          Factory(:quote, close: close, date: index.days.from_now)
        end
        
        @quote = Quote.last
      end
      
      describe "#simple_moving_average" do
        it "returns the proper simple moving average" do
          @quote.simple_moving_average(10).to_f.should eql(22.22)
        end
      end
      
      describe "#exponential_moving_average" do
        it "returns the proper EMA" do
          @quote.exponential_moving_average(10).to_f.should eql(22.22)
        end
      end
    end
  end
end
