require 'rails_helper'

RSpec.describe AtmFacade do
  describe "instance methods" do
    it "atm_details" do
      market = create(:market, lat: 37.583311, lon: -79.048573)
      facade1 = AtmFacade.new(market)

      expect(facade1.atm_details).to be_an(Array)  
      
      facade1.atm_details.each do |atm|

      expect(atm).to be_a(Atm)
      expect(atm.address).to be_a(String)
      expect(atm.distance).to be_a(Float)
      expect(atm.lat).to be_a(Float)
      expect(atm.lon).to be_a(Float)
      expect(atm.name).to be_a(String)
      end
    end
  end
end