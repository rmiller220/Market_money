require './app/poros/atm'

class AtmFacade
  def initialize(market)
    @lat = market.lat.to_f
    @lon = market.lon.to_f
  end
  
  def atm_details
     json = AtmService.new.closest_atm(@lon, @lat)
     json[:results].map do |result|
      Atm.new(result)
     end
  end
end