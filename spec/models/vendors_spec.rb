require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:markets).through(:market_vendors)}
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :contact_name }
    it { should validate_presence_of :contact_phone }
    it { is_expected.to validate_presence_of(:credit_accepted) }
  end

  describe "Instance methods" do
    describe "market_vendor_delete" do
      it "deletes all associated market_vendors" do
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)

        market1 = create(:market)
        market2 = create(:market)
        market3 = create(:market)

        market_vendor1 = create(:market_vendor, vendor_id: vendor1.id, market_id: market1.id )
        market_vendor2 = create(:market_vendor, vendor_id: vendor1.id, market_id: market2.id )
        market_vendor3 = create(:market_vendor, vendor_id: vendor2.id, market_id: market3.id )

        expect(MarketVendor.count).to eq(3)

        vendor1.market_vendor_delete

        expect(MarketVendor.count).to eq(1)
        expect(vendor1.market_vendors.count).to eq(0)
        expect(vendor2.market_vendors.count).to eq(1)
      end
    end
  end
end