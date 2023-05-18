require 'rail_helper'

RSpec.describe Atm do
  describe "initialize" do
    it 'exists' do
      atm = Atm.new(address: "123 Fox St", dist: 0.5, lat: 37.583311, lon: -79.048573, name: "ATM")

      expect(atm).to be_a(Atm)
      expect(atm.address).to eq("123 Fox St")
      expect(atm.distance).to eq(0.5)
      expect(atm.lat).to eq(37.583311)
      expect(atm.lon).to eq(-79.048573)
      expect(atm.name).to eq("ATM")
    end
  end
end