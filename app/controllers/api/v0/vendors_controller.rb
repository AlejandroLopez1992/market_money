class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    vendors = Market.find(params[:market_id]).vendors
    render json: VendorSerializer.new(vendors)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create  
    vendor = Vendor.create(vendor_params)
    render json: VendorSerializer.new(vendor)
  end
  
  private 
  
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end

    def not_found(exception)
      render json: ErrorVendorSerializer.new(exception).serialized_json, status: 404
    end
end