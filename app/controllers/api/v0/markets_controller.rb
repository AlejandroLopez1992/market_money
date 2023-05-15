class Api::V0::MarketsController < ApplicationController
  def index
    render json: {
      "data" => Market.markets_format
    }
  end

  def show

  end
end