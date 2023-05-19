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
end