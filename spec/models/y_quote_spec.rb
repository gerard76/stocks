require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YQuote do
  describe "instance methods" do
    let(:quote) { YQuote.new('GOOG', [:last_trade_price_only, :change_in_percent]) }
    
    describe "#initialze" do
      it "sets the symbol" do
        quote.symbol.should eql('GOOG')
      end
      
      it "sets the properties" do
        quote.properties.should eql([:last_trade_price_only, :change_in_percent])
      end
      
      it "initializes the values to an empty hash" do
        quote.values.should eql({})
      end
    end
    
    describe "#fetch" do
      before do
        VCR.use_cassette('google_quote') do
          quote.fetch
        end
      end
      
      it "sets the requested values" do
        quote.values[:last_trade_price_only].should eql('523.57')
        quote.values[:change_in_percent].should eql('+0.92%')
      end
      
      it "does not set other values" do
        quote.values[:open].should be_nil
      end
    end
  end
end