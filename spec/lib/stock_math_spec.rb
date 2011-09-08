require 'spec_helper'

describe StockMath do
  
  describe "instance methods" do
    describe "moving averages" do
      before(:each) do
        @prices = [22.27, 22.19, 22.08, 22.17, 22.18, 22.13, 22.23, 22.43, 22.24, 22.29]
      end
      
      describe "#simple_moving_average" do
        it "returns the proper simple moving average" do
          StockMath.simple_moving_average(@prices, 10).to_f.should eql(22.22)
        end
      end
      
      describe "#exponential_moving_average" do
        it "returns the SMA if there are no more quotes to trace back to" do
          StockMath.exponential_moving_average(@prices, 10).should eql(22.22)
        end
        
        it "returns EMA if there are enough quotes" do
          StockMath.exponential_moving_average(@prices + [22.15, 22.39, 22.38], 10).should eql(22.27)
        end
        
        it "doesnt fuck up calculations for longer periods" do
          @prices = @prices + [22.15, 22.39, 22.38, 22.61, 23.36, 24.05, 23.75, 23.83, 23.95, 23.63,
                                23.82, 23.87, 23.65, 23.19, 23.10, 23.33, 22.68, 23.10, 22.40, 22.17]
          StockMath.exponential_moving_average(@prices, 10).should eql(22.92)
        end
      end
      
      describe "#macd" do
        it "returns the MACD value for given periods" do
          # 2: 22.29
          # 8: 22.24
          StockMath.macd(@prices, 2, 8).should eql(-0.05)
        end
      end
    end
  end
end
