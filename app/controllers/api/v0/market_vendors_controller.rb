class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    if market_vendor.save
      render json: MarketVendorSerializer.new(market_vendor).success, status: 201
    else
      errors_determination(market_vendor.errors)
    end
  end

  def destroy
      market_vendor = MarketVendor.find_by(market_id: market_vendor_params["market_id"], vendor_id: market_vendor_params["vendor_id"])
      if market_vendor.nil?
        render json: {
          "errors": [
                {
                    "detail": "No MarketVendor with market_id=#{market_vendor_params["market_id"]} AND vendor_id=#{market_vendor_params["vendor_id"]} exists"
                }
            ]
        }, status: 404
      else 
        render json: MarketVendor.delete(market_vendor), status: 204
      end
  end

  private

    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end

    def not_found(exception)
      render json: ErrorMarketVendorSerializer.new(exception).not_found_serialized_json, status: 404
    end

    def errors_determination(errors)
      if errors.messages.has_key?(:already_exists)
        render json: ErrorMarketVendorSerializer.new(errors).already_exists_serialized_json, status: 422
      elsif errors.messages.has_key?(:market_id) || errors.messages.has_key?(:vendor_id)
        render json: ErrorMarketVendorSerializer.new(errors).nil_values_serialized_json, status: 400
      else 
        render json: ErrorMarketVendorSerializer.new(errors).invalid_attr_serialized_json, status: 404
      end
    end
end

