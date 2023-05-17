require 'rails_helper'

RSpec.describe MarketVendor, type: :model do
  describe 'relationships' do
    it { should belong_to :market }
    it { should belong_to :vendor }
  end

  describe 'relationships' do
    before do
      create(:market, id: 1)
      create(:vendor, id: 1)
      create(:market_vendor, market_id: 1, vendor_id: 1)
    end
    it { is_expected.to validate_uniqueness_of(:market_id).scoped_to(:vendor_id) }
    it { is_expected.to validate_uniqueness_of(:vendor_id).scoped_to(:market_id) }
  end

  describe 'class methods' do
    it 'find_market_vendor' do

      market = create(:market, id: 1)
      vendor = create(:vendor, id: 1)
      market_vendor = create(:market_vendor, market_id: 1, vendor_id: 1)
      
      expect(MarketVendor.find_market_vendor(1, 1)).to eq(market_vendor)
    end
  end
end