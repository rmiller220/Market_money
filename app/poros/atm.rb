class Atm 
  attr_reader :lat, :lon, :dist, :name, :address

  def initialize(data)
    # require 'pry'; binding.pry
    @lat = data[:results][0][:position][:lat]
    @lon = data[:results][0][:position][:lon]
    @distance = data[:results][0][:dist]
    @name = data[:results][0][:poi][:name]
    @address = data[:results][0][:address][:freeformAddress]
  end
end