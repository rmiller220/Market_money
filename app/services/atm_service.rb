class AtmService

  def closest_atm(lat, lon)
    get_url("/search/2/categorySearch/ATM.json?lat=#{lat}&lon=#{lon}")
  end


  def get_url(url)
    response = conn.get(url) 
    JSON.parse(response.body, symbolize_names: true) 
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com') do |faraday|
    faraday.params['key'] = ENV['tom_tom_api_key']
    end
  end
end