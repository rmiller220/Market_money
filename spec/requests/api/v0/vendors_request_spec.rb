require 'rails_helper'

describe 'Vendors API' do
  xit 'sends a list of vendors' do
    create_list(:vendor, 3)
    get '/api/v0/vendors'

    require 'pry'; binding.pry
    expect(response).to be_successful

    vendors = JSON.parse(response.body, symbolize_names: true)

  end

  it 'can get one vendor by its id' do
    vendor1 = Vendor.create({
        id: 97,
        name: "Seurat",
        description: "Hurrah for anarchy! This is the happiest moment of my life.",
        contact_name: "Bradley Beal",
        contact_phone: "1-741-620-5747",
        credit_accepted: true})
    
    get "api/v0/vendors/#{vendor1.id}"

    vendor = JSON.parse(response.body, symbolize_names: true)

    require 'pry'; binding.pry
  end
end