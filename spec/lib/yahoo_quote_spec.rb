require 'spec_helper'

describe YahooQuote do
  describe "instance methods" do
    let(:yahoo_quote) { YahooQuote.new('GOOG', [:last_trade_price_only, :change_in_percent]) }
    
    describe "#initialze" do
      it "sets the symbol" do
        yahoo_quote.symbol.should eql('GOOG')
      end
      
      it "sets the properties" do
        yahoo_quote.properties.should eql([:last_trade_price_only, :change_in_percent])
      end
    end
    
    describe "#fetch" do
      before do
        VCR.use_cassette('Yahoo quote Google') do
          yahoo_quote.values[:day_low] = "666"
          yahoo_quote.fetch
        end
      end
      
      it "sets the requested values" do
        yahoo_quote.values[:last_trade_price_only].should eql('520.04')
        yahoo_quote.values[:change_in_percent].should eql('0.00%')
      end
      
      it "does not set other values" do
        yahoo_quote.values[:open].should be_nil
      end
    end
  end
end