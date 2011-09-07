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
        [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29].each_with_index do |close, index|
          Factory(:quote, close: close, date: index.days.from_now)
        end
      end
      
      describe "#simple_moving_average" do
        it "returns the proper simple moving average" do
          Quote.last.simple_moving_average(10).to_f.should eql(22.22)
        end
      end
      
      describe "#exponential_moving_average" do
        it "returns the SMA if there are no more quotes to trace back to" do
          quote = Quote.last
          
          quote.last.exponential_moving_average(10).should eql(quote.simple_moving_average(10))
        end
        
        it "returns EMA if there are enough quotes" do
          [22.15, 22.39, 22.38].each_with_index do |close, index|
            Factory(:quote, close: close, date: (10 + index).days.from_now)
          end
          
          Quote.last.exponential_moving_average(10).should eql(22.27)
        end
      end
    end
  end
end
