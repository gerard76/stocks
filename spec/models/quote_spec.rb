require 'spec_helper'

describe Quote do
  
  let(:quote) { Factory(:quote) }
  
  describe "validations" do
    it { should validate_presence_of(:symbol) }
    it { quote;
         should validate_uniqueness_of(:symbol).scoped_to(:date) }
  end
end
