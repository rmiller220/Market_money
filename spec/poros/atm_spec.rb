require 'rails_helper'

RSpec.describe Atm do
  describe "initialize" do
    it 'exists' do
      data = {address: {freeformAddress: "123 Fox St"}, dist: 0.5, poi: {name: "ATM"}, position: {lat: 37.583311, lon: -79.048573}}
      atm = Atm.new(data)
      
      expect(atm).to be_a(Atm)
      expect(atm.address).to eq("123 Fox St")
      expect(atm.distance).to eq(0.5)
      expect(atm.lat).to eq(37.583311)
      expect(atm.lon).to eq(-79.048573)
      expect(atm.name).to eq("ATM")
    end
  end
end