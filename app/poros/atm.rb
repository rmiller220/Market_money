class Atm 
  attr_reader :id, :lat, :lon, :distance, :name, :address

  def initialize(data)
      @lat = data[:position][:lat]
      @lon = data[:position][:lon]
      @distance = data[:dist]
      @name = data[:poi][:name]
      @address = data[:address][:freeformAddress]
      @id = nil
  end
end