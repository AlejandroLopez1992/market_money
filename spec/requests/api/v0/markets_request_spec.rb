require 'rails_helper'

describe "Markets API" do
  describe "GET /api/v0/markets" do
    it "sends all markets within a key of data" do
      create_list(:market, 8)
  
      get '/api/v0/markets'
      
      expect(response).to be_successful
  
      markets = JSON.parse(response.body, symbolize_names: true)
  
      expect(markets[:data].count).to eq(8)
  
      markets[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to be_a(String)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a(Hash)
  
        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a(String)
  
        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a(String)
  
        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a(String)
  
        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a(String)
  
        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_a(String)
  
        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_a(String)
  
        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_a(String)
  
        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_a(String)

        expect(market[:attributes]).to have_key(:vendor_count)
        expect(market[:attributes][:vendor_count]).to be_an(Integer)
      end
    end
  end

  describe "GET /api/v0/markets/:id" do
    it "should send one market based on passed in ID" do
      create_markets = create_list(:market, 7)

      get "/api/v0/markets/#{create_markets[3].id}"

      market3 = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(market3[:data]).to have_key(:id)
      expect(market3[:data][:id]).to be_a(String)

      expect(market3[:data]).to have_key(:type)
      expect(market3[:data][:type]).to be_a(String)
      expect(market3[:data][:type]).to eq("market")

      expect(market3[:data]).to have_key(:attributes)
      expect(market3[:data][:attributes]).to be_a(Hash)

      expect(market3[:data][:attributes]).to have_key(:name)
      expect(market3[:data][:attributes][:name]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:street)
      expect(market3[:data][:attributes][:street]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:city)
      expect(market3[:data][:attributes][:city]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:county)
      expect(market3[:data][:attributes][:county]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:state)
      expect(market3[:data][:attributes][:state]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:zip)
      expect(market3[:data][:attributes][:zip]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:lat)
      expect(market3[:data][:attributes][:lat]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:lon)
      expect(market3[:data][:attributes][:lon]).to be_a(String)

      expect(market3[:data][:attributes]).to have_key(:vendor_count)
      expect(market3[:data][:attributes][:vendor_count]).to be_an(Integer)
    end

    it "if input ID is not in database, error is sent" do
      market = create(:market).id

      get "/api/v0/markets/#{market}023423"
      
      expect(responce).to_not be_successful


    end
  end
end