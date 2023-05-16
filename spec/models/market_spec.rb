require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
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

  describe 'instance methods' do
    it 'can count the number of vendors at a market' do
      create(:market, id: 1)
      create(:market, id: 2)
      create(:vendor, id: 1)
      create(:vendor, id: 2)
      create(:vendor, id: 3)
      create(:market_vendor, market_id: 1, vendor_id: 1)
      create(:market_vendor, market_id: 1, vendor_id: 2)
      create(:market_vendor, market_id: 2, vendor_id: 3)

      expect(Market.first.vendor_count).to eq(2)
      expect(Market.last.vendor_count).to eq(1)
    end
  end
end
