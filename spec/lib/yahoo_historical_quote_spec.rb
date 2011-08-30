require 'spec_helper'

describe YahooHistoricalQuote do
  let(:yahoo_historical_quote) { YahooHistoricalQuote.new('GOOG', Date.new(2011, 05, 16), Date.new(2011,05, 17), :daily) }
  
  describe "instance methods" do
    describe "#initialize" do
      it "sets the symbol" do
        yahoo_historical_quote.symbol.should eql('GOOG')
      end
      
      it "sets the from_date" do
        yahoo_historical_quote.from_date.should eql(Date.new(2011, 05, 16))
      end
      
      it "sets the to_date" do
        yahoo_historical_quote.to_date.should eql(Date.new(2011,05, 17))
      end
      
      it "sets the interval" do
        yahoo_historical_quote.interval.should eql :daily
      end
    end
    
    describe "#fetch" do
      before do
        VCR.use_cassette('Yahoo historical quote Google') do
          yahoo_historical_quote.fetch
        end
      end
      
      it "skips the first header line" do
        yahoo_historical_quote.values[0][:open].should_not eql('Open')
      end
      
      it "creates a value array for every interval" do
        yahoo_historical_quote.values.should have(2).lines
      end
      
      it "sets 7 values for every interval" do
        yahoo_historical_quote.values.first.should have(7).values
      end
      
      it "sets the values" do
        yahoo_historical_quote.values[0][:date].to_s.should      eql("2011-05-17 12:00:00 +0200")
        yahoo_historical_quote.values[0][:open].should           eql("515.43")
        yahoo_historical_quote.values[0][:close].should          eql("530.46")
        yahoo_historical_quote.values[0][:volume].should         eql("3303600")
        yahoo_historical_quote.values[0][:adjusted_close].should eql("530.46")
        yahoo_historical_quote.values[0][:high].should           eql("531.22")
        yahoo_historical_quote.values[0][:low].should            eql("515.03")
      end
    end
  end
end