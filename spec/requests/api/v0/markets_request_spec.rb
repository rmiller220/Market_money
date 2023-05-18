require 'rails_helper'

describe 'Markets API' do
  it 'sends a list of markets' do
    create_list(:market, 3)
    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets).to be_a(Hash)
    expect(markets).to have_key(:data)
    expect(markets[:data].count).to eq(3)

    markets[:data].each do |market|

      expect(market).to be_an(Hash)
      expect(market).to have_key(:attributes)

      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)
      
      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)
      
      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)
      
      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)
      
      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)
    end
  end

  it 'can get one market by its id' do
    market1 = Market.create({:id=>159,
    :name=>"Adams-Parker",
    :street=>"2693 Shantell Ranch",
    :city=>"Kingstad",
    :county=>"Autumn Acres",
    :state=>"Oregon",
    :zip=>"19879",
    :lat=>"29.04595430113882",
    :lon=>"153.54201849872737"})

    get "/api/v0/markets/#{market1.id}"

    market = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful

    expect(market).to be_a(Hash)
    expect(market).to have_key(:data)

    expect(response).to be_successful

    expect(market[:data]).to have_key(:id)
    expect(market[:data][:id]).to eq("159")

    expect(market[:data][:attributes]).to have_key(:name)
    expect(market[:data][:attributes][:name]).to eq("Adams-Parker")

    expect(market[:data][:attributes]).to have_key(:street)
    expect(market[:data][:attributes][:street]).to eq("2693 Shantell Ranch")
    
    expect(market[:data][:attributes]).to have_key(:city)
    expect(market[:data][:attributes][:city]).to eq("Kingstad")
    
    expect(market[:data][:attributes]).to have_key(:county)
    expect(market[:data][:attributes][:county]).to eq("Autumn Acres")

    expect(market[:data][:attributes]).to have_key(:state)
    expect(market[:data][:attributes][:state]).to eq("Oregon")
    
    expect(market[:data][:attributes]).to have_key(:zip)
    expect(market[:data][:attributes][:zip]).to eq("19879")

    expect(market[:data][:attributes]).to have_key(:lat)
    expect(market[:data][:attributes][:lat]).to eq("29.04595430113882")
    
    expect(market[:data][:attributes]).to have_key(:lon)
    expect(market[:data][:attributes][:lon]).to eq("153.54201849872737")
  end

  it 'sad path for market show' do

    get "/api/v0/markets/123123123123"

    market = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(market[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
  end

  it 'can get all vendors for a market' do
    market = create(:market)
    vendor1 = create(:vendor)
    vendor2 = create(:vendor)
    vendor3 = create(:vendor)
    market.vendors << vendor1
    market.vendors << vendor2

    get "/api/v0/markets/#{market.id}/vendors"

    market_vendors = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    
    expect(market_vendors).to be_a(Hash)
    expect(market_vendors).to have_key(:data)
    expect(market_vendors[:data].count).to eq(2)

    expect(market_vendors[:data][0]).to be_an(Hash)
    expect(market_vendors[:data][0]).to have_key(:id)
    expect(market_vendors[:data][0][:id]).to be_an(String)
    expect(market_vendors[:data][0][:id]).to eq(vendor1.id.to_s)
    expect(market.vendors[0].id).to eq(vendor1.id)

    expect(market_vendors[:data][0]).to have_key(:attributes)
    expect(market_vendors[:data][0][:attributes]).to have_key(:name)
    expect(market_vendors[:data][0][:attributes][:name]).to be_a(String)
    expect(market_vendors[:data][0][:attributes][:name]).to eq(vendor1.name)
    expect(market.vendors[0].name).to eq(vendor1.name)

    expect(market_vendors[:data][0][:attributes]).to have_key(:description)
    expect(market_vendors[:data][0][:attributes][:description]).to be_a(String)
    expect(market_vendors[:data][0][:attributes][:description]).to eq(vendor1.description)
    expect(market.vendors[0].description).to eq(vendor1.description)

    expect(market_vendors[:data][0][:attributes]).to have_key(:contact_name)
    expect(market_vendors[:data][0][:attributes][:contact_name]).to be_a(String)
    expect(market_vendors[:data][0][:attributes][:contact_name]).to eq(vendor1.contact_name)
    expect(market.vendors[0].contact_name).to eq(vendor1.contact_name)

    expect(market_vendors[:data][0][:attributes]).to have_key(:contact_phone)
    expect(market_vendors[:data][0][:attributes][:contact_phone]).to be_a(String)
    expect(market_vendors[:data][0][:attributes][:contact_phone]).to eq(vendor1.contact_phone)
    expect(market.vendors[0].contact_phone).to eq(vendor1.contact_phone)

    expect(market_vendors[:data][0][:attributes]).to have_key(:credit_accepted)
    expect(market_vendors[:data][0][:attributes][:credit_accepted]).to be_in([true, false])
    expect(market_vendors[:data][0][:attributes][:credit_accepted]).to eq(vendor1.credit_accepted)
    expect(market.vendors[0].credit_accepted).to eq(vendor1.credit_accepted)

    expect(vendor3).to_not be_in(market.vendors)
  end

  it 'sad path for market vendors' do

    get "/api/v0/markets/123123123123/vendors"

    market = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(market[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
  end

  it 'can search for markets by state, name, city' do
    market1 = Market.create({:id=>159,
      :name=>"Adams-Parker",
      :street=>"2693 Shantell Ranch",
      :city=>"Kingstad",
      :county=>"Autumn Acres",
      :state=>"Oregon",
      :zip=>"19879",
      :lat=>"29.04595430113882",
      :lon=>"153.54201849872737"})

    market2 = Market.create({id: 455,
      name: "Schmidt, Hintz and Rempel",
      street: "377 Von Plains",
      city: "Chaston",
      county: "Royal Square",
      state: "New York",
      zip: "31983-5120",
      lat: "-22.547007464861437",
      lon: "102.72548129421153"})
    query = {city: "Chaston", name: "Schmidt, Hintz and Rempel", state: "New York"}

    get "/api/v0/markets/search", params: query
    
    market_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(market_search).to be_a(Hash)
    expect(market_search).to have_key(:data)
    expect(market_search[:data].count).to eq(1)
    expect(market_search[:data]).to be_an(Array)

    expect(market_search[:data][0]).to be_an(Hash)
    expect(market_search[:data][0]).to have_key(:id)
    expect(market_search[:data][0][:id]).to be_an(String)
    expect(market_search[:data][0][:id]).to eq(market2.id.to_s)

    expect(market_search[:data][0]).to have_key(:attributes)
    expect(market_search[:data][0][:attributes]).to have_key(:name)
    expect(market_search[:data][0][:attributes][:name]).to be_a(String)
    expect(market_search[:data][0][:attributes][:name]).to eq(market2.name)

    expect(market_search[:data][0][:attributes]).to have_key(:city)
    expect(market_search[:data][0][:attributes][:city]).to be_a(String)
    expect(market_search[:data][0][:attributes][:city]).to eq(market2.city)

    expect(market_search[:data][0][:attributes]).to have_key(:state)
    expect(market_search[:data][0][:attributes][:state]).to be_a(String)
    expect(market_search[:data][0][:attributes][:state]).to eq(market2.state)
  end

  it 'can search for markets by state and city' do
    market1 = create(:market, state: "Oregon", name: "Adams-Parker", city: "Kingstad")

    market2 = create(:market, state: "New York", name: "Schmidt, Hintz and Rempel", city: "Chaston")

    market3 = create(:market, state: "New York", name: "Bob the Builder", city: "Brooklyn")

    get "/api/v0/markets/search", params: {city: "Chaston", state: "New York"}

    market_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(market_search).to be_a(Hash)
    expect(market_search).to have_key(:data)
    expect(market_search[:data].count).to eq(1)
    expect(market_search[:data]).to be_an(Array)
    expect(market_search[:data][0]).to be_an(Hash)
    expect(market_search[:data][0]).to have_key(:id)
    expect(market_search[:data][0][:id]).to eq(market2.id.to_s)
  end

  it 'can search for markets by state' do
    market1 = create(:market, state: "Oregon", name: "Adams-Parker", city: "Kingstad")

    market2 = create(:market, state: "New York", name: "Schmidt, Hintz and Rempel", city: "Chaston")

    market3 = create(:market, state: "New York", name: "Bob the Builder", city: "Brooklyn")

    get "/api/v0/markets/search", params: {state: "New York"}
    
    market_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(market_search).to be_a(Hash)
    expect(market_search).to have_key(:data)
    expect(market_search[:data].count).to eq(2)
    expect(market_search[:data]).to be_an(Array)
    expect(market_search[:data][0]).to be_an(Hash)
    expect(market_search[:data][0]).to have_key(:id)
    expect(market_search[:data][0][:id]).to eq(market2.id.to_s)
    expect(market_search[:data][1][:id]).to eq(market3.id.to_s)
  end

  it 'can search for markets by state and name' do
    market1 = create(:market, state: "Oregon", name: "Adams-Parker", city: "Kingstad")

    market2 = create(:market, state: "New York", name: "Schmidt, Hintz and Rempel", city: "Chaston")

    market3 = create(:market, state: "New York", name: "Bob the Builder", city: "Brooklyn")

    get "/api/v0/markets/search", params: {state: "New York", name: "Bob the Builder"}
    
    market_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(market_search).to be_a(Hash)
    expect(market_search).to have_key(:data)
    expect(market_search[:data].count).to eq(1)
    expect(market_search[:data]).to be_an(Array)
    expect(market_search[:data][0]).to be_an(Hash)
    expect(market_search[:data][0]).to have_key(:id)
    expect(market_search[:data][0][:id]).to eq(market3.id.to_s)
  end

  it 'can search for markets by name' do
    market1 = create(:market, state: "Oregon", name: "Adams-Parker", city: "Kingstad")

    market2 = create(:market, state: "New York", name: "Schmidt, Hintz and Rempel", city: "Chaston")

    market3 = create(:market, state: "New York", name: "Bob the Builder", city: "Brooklyn")

    get "/api/v0/markets/search", params: {name: "Bob the Builder"}
    
    market_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(market_search).to be_a(Hash)
    expect(market_search).to have_key(:data)
    expect(market_search[:data].count).to eq(1)
    expect(market_search[:data]).to be_an(Array)
    expect(market_search[:data][0]).to be_an(Hash)
    expect(market_search[:data][0]).to have_key(:id)
    expect(market_search[:data][0][:id]).to eq(market3.id.to_s)
  end


  it 'cannot search for markets by just city' do
    market1 = create(:market, state: "Oregon", name: "Adams-Parker", city: "Kingstad")

    market2 = create(:market, state: "New York", name: "Schmidt, Hintz and Rempel", city: "Chaston")

    market3 = create(:market, state: "New York", name: "Bob the Builder", city: "Brooklyn")

    get "/api/v0/markets/search", params: {city: "Brooklyn"}
    
    market_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(422)
    expect(market_search[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
  end

  it 'cannot search for markets by just city/name' do
    market1 = create(:market, state: "Oregon", name: "Adams-Parker", city: "Kingstad")

    market2 = create(:market, state: "New York", name: "Schmidt, Hintz and Rempel", city: "Chaston")

    market3 = create(:market, state: "New York", name: "Bob the Builder", city: "Brooklyn")

    get "/api/v0/markets/search", params: {city: "Brooklyn", name: "Bob the Builder"}
    
    market_search = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(422)
    expect(market_search[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
  end

  it 'can find the closest atm to a market' do
    market1 = Market.create({:id=>159,
    :name=>"Adams-Parker",
    :street=>"2693 Shantell Ranch",
    :city=>"Kingstad",
    :county=>"Autumn Acres",
    :state=>"Oregon",
    :zip=>"19879",
    :lat=>"37.583311",
    :lon=>"-79.048573"})

    market2 = Market.create({id: 455,
      name: "Schmidt, Hintz and Rempel",
      street: "377 Von Plains",
      city: "Chaston",
      county: "Royal Square",
      state: "New York",
      zip: "31983-5120",
      lat: "-22.5470074648",
      lon: "102.7254812942"})

    get "/api/v0/markets/#{market1.id}/nearest_atms"

    atm_request = JSON.parse(response.body, symbolize_names: true)
    require 'pry'; binding.pry
  end
end