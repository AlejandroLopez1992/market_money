class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    vendors = Market.find(params[:market_id]).vendors
    render json: VendorSerializer.new(vendors)
  end

  private 

    def not_found(exception)
      render json: ErrorVendorSerializer.new(exception).serialized_json, status: 404
    end
end