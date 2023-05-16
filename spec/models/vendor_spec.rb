require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :contact_name }
    it { should validate_presence_of :contact_phone }
    it { should validate_inclusion_of(:credit_accepted).in_array([true, false]) }

    it 'validates boolean for credit_accepted' do
      vendor1 = Vendor.create(name: "Test1", description: "Test1", contact_name: "Test1", contact_phone: "Test1", credit_accepted: "True")
      vendor2 = Vendor.create(name: "Test2", description: "Test2", contact_name: "Test2", contact_phone: "Test2", credit_accepted: "false")
      vendor3 = Vendor.create(name: "Test3", description: "Test3", contact_name: "Test3", contact_phone: "Test3")

      expect(vendor1.valid?).to eq(true)
      expect(vendor2.valid?).to eq(true)
      expect(vendor3.valid?).to eq(false)
    end
  end

  
end