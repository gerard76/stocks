class QuoteController < ApplicationController
  def show
    @quote = Quote.find_by_symbol(params[:id]).last
  end
end
