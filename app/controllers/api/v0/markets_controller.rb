class Api::V0::MarketsController < ApplicationController
  def index
    render json: {
      "data" => Market.all
    }
  end

  def show

  end
end