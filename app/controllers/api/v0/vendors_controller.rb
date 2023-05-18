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
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor), status: 201
    else 
      render json: ErrorVendorSerializer.new(vendor.errors).invalid_attr_serialized_json, status: 400
    end
  end
  
  def update
    vendor = Vendor.find(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor), status: 201
    else 
      render json: ErrorVendorSerializer.new(vendor.errors).invalid_attr_serialized_json, status: 400
    end
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.market_vendor_delete
    render json: Vendor.delete(params[:id]), status: 204
  end

  private 
  
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end

    def not_found(exception)
      render json: ErrorVendorSerializer.new(exception).not_found_serialized_json, status: 404
    end
end