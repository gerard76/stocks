require 'spec_helper'

describe Quote do
  
  let(:quote) { Factory(:quote) }
  
  describe "validations" do
    it { should validate_presence_of(:symbol) }
    it { quote;
         should validate_uniqueness_of(:symbol).scoped_to(:date) }
  end
  
  describe "instance methods" do
    before do
      [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29].each_with_index do |price, index|
        Factory(:quote, close: price, date: index.days.from_now)
      end
    end
    
    describe "macd" do
      it "returns the proper macd" do
        Quote.last.macd(2, 8).should eql(-0.05)
      end
    end
  end
end
