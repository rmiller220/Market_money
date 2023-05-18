require './app/poros/atm'

class AtmFacade
  def initialize(market)
    @lat = market.lat.to_f
    @lon = market.lon.to_f
    # require 'pry'; binding.pry
  end
  
  def atm_details
    Atm.new(AtmService.new.closest_atm(@lon, @lat))
  end
end