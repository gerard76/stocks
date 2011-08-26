class QuotesController < ApplicationController
  respond_to :html, :csv
  
  def index
    @symbols = Quote.symbols.map(&:symbol)
  end
  
  def show
    @quotes = Quote.where(symbol: params[:id] || params[:quote_id])
    respond_with @quotes
  end
end
