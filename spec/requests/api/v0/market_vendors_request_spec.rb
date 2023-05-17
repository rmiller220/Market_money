require 'rails_helper'

describe 'Market Vendors API' do
  it "can create a market vendor" do
    create(:market, id: 1)
    create(:vendor, id: 1)
    post "/api/v0/market_vendors", params: { market_id: 1, vendor_id: 1 }

    new_market_vendor = MarketVendor.last
    market_vendor = JSON.parse(response.body, symbolize_names: true)

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

  it 'sad path for market vendors, must have vendor_id' do
    create(:market, id: 1)

    post "/api/v0/market_vendors", params: { market_id: 1 }

    market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(market_vendor[:errors][0][:detail]).to eq("Vendor must exist")
  end

  it 'sad path for market vendors, must have market_id' do
    create(:vendor, id: 1)

    post "/api/v0/market_vendors", params: { vendor_id: 1 }

    market_vendor = JSON.parse(response.body, symbolize_names: true)
    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(market_vendor[:errors][0][:detail]).to eq("Market must exist")
  end

  it 'sad path for market vendors, must have unique combination of market_id and vendor_id' do
    create(:market, id: 1)
    create(:market, id: 2)
    create(:vendor, id: 1)
    create(:vendor, id: 2)
    create(:market_vendor, market_id: 1, vendor_id: 1)
    create(:market_vendor, market_id: 2, vendor_id: 2)
    create(:market_vendor, market_id: 1, vendor_id: 2)
    create(:market_vendor, market_id: 2, vendor_id: 1)

    post "/api/v0/market_vendors", params: { market_id: 2, vendor_id: 1 }

    market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(422)
    expect(market_vendor[:errors][0][:detail]).to eq("Validation failed: Market vendor asociation between market with market_id=2 and vendor_id=1 already exists")
  end

  it 'can delete a market vendor' do
    market1 = create(:market, id: 1)
    vendor1 = create(:vendor, id: 1)
    vendor2 = create(:vendor, id: 2)
    vendor3 = create(:vendor, id: 3)
    market_vendor1 = create(:market_vendor, id: 1, market_id: 1, vendor_id: 1)
    market_vendor2 = create(:market_vendor, id: 2, market_id: 1, vendor_id: 2)
    market_vendor3 = create(:market_vendor, id: 3, market_id: 1, vendor_id: 3)
    
    expect(MarketVendor.count).to eq(3)
    
    delete "/api/v0/market_vendors", params: { market_id: 1, vendor_id: 1 }

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(MarketVendor.count).to eq(2)
    expect{MarketVendor.find(1)}.to raise_error(ActiveRecord::RecordNotFound)

    get "/api/v0/markets/1/vendors"

    market = JSON.parse(response.body, symbolize_names: true)

    expect(market[:data].count).to eq(2)
    expect(market[:data][0][:id]).to eq("2")
    expect(market[:data][1][:id]).to eq("3")
    expect(vendor1).to_not be_in(market[:data])
  end

  it 'sad path for deleting market vendors, must have vendor_id and market_id' do
    market1 = create(:market, id: 1)
    vendor1 = create(:vendor, id: 1)

    delete "/api/v0/market_vendors", params: { market_id: 1, vendor_id: 1}

    market_vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(market_vendor[:errors][0][:detail]).to eq("No market vendor asociation between market with market_id=1 and vendor_id=1 exists")
  end
end