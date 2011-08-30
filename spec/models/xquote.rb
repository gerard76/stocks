require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XQuote do
  describe "instance methods" do
    let(:quote) { Quote.new('GOOG') }
    
    describe "#initialze" do
      it "sets the symbol" do
        quote.symbol.should eql('GOOG')
      end
    end
    
    describe "#fetch" do
      before do
        VCR.use_cassette('google_quote') do
          quote.fetch
        end
      end
      
      google_quote = { 
        symbol:                     'GOOG',
        name:                       'Google Inc.',
        last_trade_price_only:      '523.29',
        last_trade_date:            '8/24/2011',
        last_trade_time:            '4:00pm',
        change_with_percent_change: '+4.47 - +0.86%',
        change:                     '+4.47',
        previous_close:             '518.82',
        change_in_percent:          '+0.86%',
        open:                       '519.00',
        day_low:                    '517.23',
        day_high:                   '530.00',
        volume:                     '3598264',
        last_trade_with_time:       'Aug 24 - <b>523.29</b>',
        day_range:                  '517.23 - 530.00',
        ticker_trend:               '&nbsp;======&nbsp;',
        ask:                        '550.00',
        average_daily_volume:       '3748470',
        bid:                        '512.09',
        bid_size:                   '161.128'
      }
      
      google_quote.each do |property, value|
        it "sets ''#{property}' to '#{value}'" do
          quote.send(property).should eql(value)
        end
      end
    end
  end
end