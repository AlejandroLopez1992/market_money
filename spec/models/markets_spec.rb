require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors)}
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :county }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :lat }
    it { should validate_presence_of :lon }
  end

  describe "class methods" do
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
  end
end