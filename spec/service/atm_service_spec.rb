require 'rails_helper'

RSpec.describe AtmService do
  describe "instance methods" do
    it "closest_atm" do
      atm_service = AtmService.new
      atm1 = atm_service.closest_atm(37.583311, -79.048573)

      expect(atm1).to be_a(Hash)
      expect(atm1).to have_key(:summary)
      expect(atm1).to have_key(:results)
      expect(atm1[:results]).to be_an(Array)
      expect(atm1[:results][0]).to have_key(:dist)
      expect(atm1[:results][0][:dist]).to be_a(Float)
      expect(atm1[:results][0][:dist] < atm1[:results][1][:dist]).to eq(true)

    end
  end
end