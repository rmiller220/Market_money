require 'rails_helper'

describe 'Markets API' do
  it 'sends a list of markets' do
    create_list(:market, 3)
    get '/api/v0/markets'

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
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
end