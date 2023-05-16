require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors)}
  end

  # describe 'validations' do
  #   it { should validate_presence_of :name }
  #   it { should validate_presence_of :street }
  #   it { should validate_presence_of :city }
  #   it { should validate_presence_of :county }
  #   it { should validate_presence_of :state }
  #   it { should validate_presence_of :zip }
  #   it { should validate_presence_of :lat }
  #   it { should validate_presence_of :lon }
  # end

  describe "class methods" do
    describe "markets format" do
      it "formats all markets into new key value pairs" do
        market = create_list(:market, 3)

        expect(Market.markets_format).to eq([
          {
          "id": market[0].id.to_s,
          "type": "market",
          "attributes": {
            "name": market[0].name,
            "street": market[0].street,
            "city": market[0].city,
            "county": market[0].county,
            "state": market[0].state,
            "zip": market[0].zip,
            "lat": market[0].lat,
            "lon": market[0].lon,
            "vendor_count": market[0].vendor_count
          } 
        },
        {
          "id": market[1].id.to_s,
          "type": "market",
          "attributes": {
            "name": market[1].name,
            "street": market[1].street,
            "city": market[1].city,
            "county": market[1].county,
            "state": market[1].state,
            "zip": market[1].zip,
            "lat": market[1].lat,
            "lon": market[1].lon,
            "vendor_count": market[1].vendor_count
          } 
        },
        {
          "id": market[2].id.to_s,
          "type": "market",
          "attributes": {
            "name": market[2].name,
            "street": market[2].street,
            "city": market[2].city,
            "county": market[2].county,
            "state": market[2].state,
            "zip": market[2].zip,
            "lat": market[2].lat,
            "lon": market[2].lon,
            "vendor_count": market[2].vendor_count
          } 
        }
      ])
      end
    end
  end

  describe "instance methods" do
    describe "vendor_count" do
      it "provides the count of vendor associated to this market" do
        market = create(:market)
        market2 = create(:market)
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)
        vendor3 = create(:vendor)
        create(:market_vendor, market_id: market.id, vendor_id: vendor1.id)
        create(:market_vendor, market_id: market.id, vendor_id: vendor2.id)
        create(:market_vendor, market_id: market.id, vendor_id: vendor3.id)
  
        create(:market_vendor, market_id: market2.id, vendor_id: vendor3.id)
        create(:market_vendor, market_id: market2.id, vendor_id: vendor1.id)
  
        expect(market.vendor_count).to eq(3)
        expect(market2.vendor_count).to eq(2)
      end
    end

    describe "market_format" do
      it "formats selected market into new key value pairs" do
        market = create(:market)

        expect(market.market_format).to eq(
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
        })
      end
    end
  end
end