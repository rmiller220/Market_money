require 'rails_helper'

describe 'Market Vendors API' do
  it "can create a market vendor" do
    create(:market, id: 1)
    create(:vendor, id: 1)
    post "/api/v0/market_vendors", params: { market_id: 1, vendor_id: 1 }

    new_market_vendor = MarketVendor.last
    market_vendor = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(response).to be_successful
    expect(market_vendor).to be_a(Hash)
    expect(market_vendor).to have_key(:data)

    expect(market_vendor[:data]).to be_a(Hash)
    expect(market_vendor[:data]).to have_key(:id)
    expect(market_vendor[:data][:id]).to be_an(String)
    expect(market_vendor[:data][:id]).to eq(new_market_vendor.id.to_s)

    expect(market_vendor[:data]).to have_key(:attributes)
    expect(market_vendor[:data][:attributes]).to have_key(:market_id)
    expect(market_vendor[:data][:attributes][:market_id]).to be_an(Integer)
    expect(market_vendor[:data][:attributes][:market_id]).to eq(new_market_vendor.market_id)

    expect(market_vendor[:data][:attributes]).to have_key(:vendor_id)
    expect(market_vendor[:data][:attributes][:vendor_id]).to be_an(Integer)
    expect(market_vendor[:data][:attributes][:vendor_id]).to eq(new_market_vendor.vendor_id)
  end
end