class Api::V0::VendorsController < ApplicationController
  def index
    vendors = Market.find(params[:market_id]).vendors
    render json: VendorSerializer.new(vendors)
  end
end