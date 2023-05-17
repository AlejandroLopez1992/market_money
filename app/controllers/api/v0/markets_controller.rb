class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :market_not_found

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end


  private
   
    def market_not_found(exception)
      render json: ErrorMarketSerializer.new(exception).serialized_json, status: 404
    end
end