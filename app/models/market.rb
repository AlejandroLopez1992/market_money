class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  # validates :name, presence: true
  # validates :street, presence: true
  # validates :city, presence: true
  # validates :county, presence: true
  # validates :state, presence: true
  # validates :zip, presence: true
  # validates :lat, presence: true
  # validates :lon, presence: true

  def vendor_count
    vendors.count
  end

  def self.markets_format
    Market.all.map do |market|
       {
          "id": market.id.to_s,
          "type": "market",
          "attributes": {
            "name": market.name,
            "street": market.street,
            "city": market.city,
            "county": market.county,
            "state": market.state,
            "zip": market.zip,
            "lat": market.lat,
            "lon": market.lon,
            "vendor_count": market.vendor_count
          } 
        }
    end
  end

  def market_format
    {
          "id": self.id.to_s,
          "type": "market",
          "attributes": {
            "name": self.name,
            "street": self.street,
            "city": self.city,
            "county": self.county,
            "state": self.state,
            "zip": self.zip,
            "lat": self.lat,
            "lon": self.lon,
            "vendor_count": self.vendor_count
          } 
        }
  end
end