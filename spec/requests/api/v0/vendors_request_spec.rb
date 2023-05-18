require 'rails_helper'

describe "Vendors API" do
  describe "GET /api/v0/vendors/:id" do
    it "sends one vendor based on passed ID" do
      create_vendors = create_list(:vendor, 5)

      get "/api/v0/vendors/#{create_vendors[4].id}"

      vendor5 = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(vendor5[:data]).to have_key(:id)
      expect(vendor5[:data][:id]).to be_a(String)

      expect(vendor5[:data]).to have_key(:type)
      expect(vendor5[:data][:type]).to be_a(String)
      expect(vendor5[:data][:type]).to eq("vendor")

      expect(vendor5[:data]).to have_key(:attributes)
      expect(vendor5[:data][:attributes]).to be_a(Hash)

      expect(vendor5[:data][:attributes]).to have_key(:name)
      expect(vendor5[:data][:attributes][:name]).to be_a(String)

      expect(vendor5[:data][:attributes]).to have_key(:description)
      expect(vendor5[:data][:attributes][:description]).to be_a(String)

      expect(vendor5[:data][:attributes]).to have_key(:contact_name)
      expect(vendor5[:data][:attributes][:contact_name]).to be_a(String)

      expect(vendor5[:data][:attributes]).to have_key(:contact_phone)
      expect(vendor5[:data][:attributes][:contact_phone]).to be_a(String)
     
      expect(vendor5[:data][:attributes]).to have_key(:credit_accepted)
      expect([TrueClass, FalseClass]).to include(vendor5[:data][:attributes][:credit_accepted].class)
    end

    it "if input ID is not in database, error is sent" do

      get "/api/v0/vendors/123144342134234"

      expect(response.status).to eq(404)
      expect(response).to_not be_successful

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(error_message).to eq({
            "errors": [
                {
                    "detail": "Couldn't find Vendor with 'id'=123144342134234"
                }
            ]
        }
          )
    end
  end

  describe "POST /api/v0/vendors" do
    it "is passed attributes required as JSON and creates a new vendor" do
      vendor_params = ({
        "name": "Buzzy Bees",
        "description": "local honey and wax products",
        "contact_name": "Berly Couwer",
        "contact_phone": "8389928383",
        "credit_accepted": false
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      created_vendor = Vendor.last

      created_vendor_formatted = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(created_vendor_formatted[:data]).to have_key(:id)
      expect(created_vendor_formatted[:data][:id]).to be_a(String)

      expect(created_vendor_formatted[:data]).to have_key(:type)
      expect(created_vendor_formatted[:data][:type]).to be_a(String)
      expect(created_vendor_formatted[:data][:type]).to eq("vendor")

      expect(created_vendor_formatted[:data]).to have_key(:attributes)
      expect(created_vendor_formatted[:data][:attributes]).to be_a(Hash)

      expect(created_vendor_formatted[:data][:attributes]).to have_key(:name)
      expect(created_vendor_formatted[:data][:attributes][:name]).to be_a(String)

      expect(created_vendor_formatted[:data][:attributes]).to have_key(:description)
      expect(created_vendor_formatted[:data][:attributes][:description]).to be_a(String)

      expect(created_vendor_formatted[:data][:attributes]).to have_key(:contact_name)
      expect(created_vendor_formatted[:data][:attributes][:contact_name]).to be_a(String)

      expect(created_vendor_formatted[:data][:attributes]).to have_key(:contact_phone)
      expect(created_vendor_formatted[:data][:attributes][:contact_phone]).to be_a(String)
     
      expect(created_vendor_formatted[:data][:attributes]).to have_key(:credit_accepted)
      expect(created_vendor_formatted[:data][:attributes][:credit_accepted]).to eq(false)


      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end

    it "if passed attributes are missing or boolean is nil, error 400 is sent with message" do
      vendor_params = ({
            "name": "Buzzy Bees",
            "description": "local honey and wax products",
            "credit_accepted": nil
        }
      )
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response.status).to eq(400)
      expect(response).to_not be_successful

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(error_message).to eq({
            "errors": [
                {
                    "detail": "Validation failed: Contact name can't be blank, Contact phone can't be blank, Credit accepted can't be blank"
                }
            ]
        }
          )
    end
  end
  describe "POST /api/v0/vendors/:id" do
    it "can patch attributes passed as JSON to a vendor" do
      vendor_id = create(:vendor, credit_accepted: true).id
      original_vendor = Vendor.last

      vendor_params = {
          "contact_name": "Kimberly Couwer",
          "credit_accepted": false
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{vendor_id}", headers: headers, params: JSON.generate({vendor: vendor_params})

      vendor = Vendor.find_by(id: vendor_id)

      expect(response).to be_successful
      expect(vendor.contact_name).to_not eq(original_vendor.contact_name)
      expect(vendor.credit_accepted).to_not eq(original_vendor.credit_accepted)
      expect(vendor.contact_name).to eq("Kimberly Couwer")
      expect(vendor.credit_accepted).to eq(false)
    end

    it "if input ID is not in database, error is sent" do
      vendor_params = {
          "contact_name": "Kimberly Couwer",
          "credit_accepted": false
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/7384638495", headers: headers, params: JSON.generate({vendor: vendor_params})

      expect(response.status).to eq(404)
      expect(response).to_not be_successful

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(error_message).to eq({
            "errors": [
                {
                    "detail": "Couldn't find Vendor with 'id'=7384638495"
                }
            ]
        }
          )
    end

    it "if passed attributes are missing or boolean is nil, error 400 is sent with message" do
      vendor_id = create(:vendor, credit_accepted: true).id

      vendor_params = {
          "contact_name": "",
          "credit_accepted": nil
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{vendor_id}", headers: headers, params: JSON.generate({vendor: vendor_params})

      expect(response.status).to eq(400)
      expect(response).to_not be_successful

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(error_message).to eq({
            "errors": [
                {
                    "detail": "Validation failed: Contact name can't be blank, Credit accepted can't be blank"
                }
            ]
        }
          )
    end
  end

  describe "DELETE /api/v0/vendors/:id" do
    it "destroys vendor and all associations" do
      vendor = create(:vendor)
      market = create(:market)
      market_vendor = create(:market_vendor, vendor_id: vendor.id, market_id: market.id )

      expect(Vendor.count).to eq(1)
      expect(MarketVendor.count).to eq(1)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(Vendor.count).to eq(0)
      expect(MarketVendor.count).to eq(0)

      expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "if input ID is not in database, error is sent" do
      vendor = create(:vendor)
      market = create(:market)
      market_vendor = create(:market_vendor, vendor_id: vendor.id, market_id: market.id )

      delete "/api/v0/vendors/23402938402398"

      expect(response.status).to eq(404)
      expect(response).to_not be_successful

      error_message = JSON.parse(response.body, symbolize_names: true)
      
      expect(error_message).to eq({
            "errors": [
                {
                    "detail": "Couldn't find Vendor with 'id'=23402938402398"
                }
            ]
        }
          )
    end
  end

end