require './app/poros/atm'

class AtmFacade
  def initialize(market)
    @lat = market.lat.to_f
    @lon = market.lon.to_f
    # require 'pry'; binding.pry
  end
  
  def atm_details
     json = AtmService.new.closest_atm(@lon, @lat)
    #  require 'pry'; binding.pry
     json[:results].map do |result|
      Atm.new(result)
     end
  end
end