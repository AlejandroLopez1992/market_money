require 'rails_helper'

describe "MarketVendors API" do
  describe "POST /api/v0/market_vendors" do
    it "is passed valid ids as JSON and creates a new market vendor" do
      market = create(:market)
      vendor = create(:vendor)

      expect(vendor.markets.count).to eq(0)
      expect(market.vendors.count).to eq(0)

      market_vendor_params = {
          "market_id": market.id,
          "vendor_id": vendor.id
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      formatted_responce = JSON.parse(response.body, symbolize_names: true)

      expect(formatted_responce).to be_a(Hash)
      expect(formatted_responce).to have_key(:message)
      expect(formatted_responce[:message]).to eq("Successfully added vendor to market")

      expect(vendor.markets).to include(market)
      expect(market.vendors).to include(vendor)
    end

    it "if input id(s) are not valid, error 404 with message is sent" do
      market_vendor_params = {
          "market_id": 1209356,
          "vendor_id": 3847584
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({
        "errors": [
              {
                  "detail": "Validation failed: Market must exist, Vendor must exist"
              }
          ]
      }
        )
    end

    it "if vendor or market id are not passed in, error 400 with message is sent" do
      market_vendor_params = {
          "market_id": "",
          "vendor_id": nil
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response.status).to eq(400)
      expect(response).to_not be_successful

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({
            "errors": [
                {
                    "detail": "Validation failed: Market can't be blank, Vendor can't be blank"
                }
            ]
        }
          )
    end

    it "if market vendor already exists based on ids, error 422 with message is sent" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = create(:market_vendor, market_id: market.id, vendor_id: vendor.id)

      market_vendor_params = {
          "market_id": market.id,
          "vendor_id": vendor.id
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({
        "errors": [
                  {
                      "detail": "Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists"
                  }
              ]
          }
        )
    end
  end

  describe "DELETE /api/v0/market_vendors" do
    it "destorys the existing market_vendor" do
      vendor = create(:vendor)
      market = create(:market)
      market_vendor = create(:market_vendor, vendor_id: vendor.id, market_id: market.id )

      expect(MarketVendor.count).to eq(1)
      expect(market.vendors.count).to eq(1)

      market_vendor_params = {
          "market_id": market.id,
          "vendor_id": vendor.id
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)


      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(MarketVendor.count).to eq(0)
      expect(market.vendors.count).to eq(0)

      expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "if passed in ids do not lead to a found MarketVEndor, error 404 is sent" do
      vendor = create(:vendor)
      market = create(:market)
      market_vendor = create(:market_vendor, vendor_id: vendor.id, market_id: market.id )


      market_vendor_params = {
          "market_id": market.id,
          "vendor_id": 11111111
      }

      headers = {"CONTENT_TYPE" => "application/json"}

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response.status).to eq(404)
      expect(response).to_not be_successful

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(error_message).to eq({
              "errors": [
                  {
                      "detail": "No MarketVendor with market_id=#{market.id} AND vendor_id=11111111 exists"
                  }
              ]
          }
        )
    end
  end
end