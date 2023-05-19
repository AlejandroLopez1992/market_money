class MarketVendor < ApplicationRecord
  validate :market_vendor_exist
  belongs_to :market
  belongs_to :vendor

  validates :market_id, presence: true
  validates :vendor_id, presence: true

  def market_vendor_exist
    if MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id) != nil
      errors.add(:already_exists, "Market vendor asociation between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
    end
  end

  # def market_and_vendor_check
  #   if Market.find(market_id) == ActiveRecord::RecordNotFound || Vendor.find(vendor_id) == ActiveRecord::RecordNotFound
  #     errors.add(:not_found, "No MarketVendor with market_id=#{market_id} AND vendor_id=#{vendor_id} exists")
  #   end
  # end
end