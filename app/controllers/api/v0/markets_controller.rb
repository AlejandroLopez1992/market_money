class Api::V0::MarketsController < ApplicationController
  def index
    render json: {
      "data" => Market.markets_format
    }
  end

  def show
    return market_not_found(params[:id]) if Market.find(params[:id]) == nil
      render json: {
        "data" => Market.find(params[:id]).market_format
      }
  end
end