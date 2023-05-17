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
    it "passed attributes required as JSON and creates a new vendor" do
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
    end
  end
end