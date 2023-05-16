require 'rails_helper'

describe 'Vendors API' do
  it 'can get one vendor by its id' do
    vendor1 = Vendor.create!({
        id: 97,
        name: "Seurat",
        description: "Hurrah for anarchy! This is the happiest moment of my life.",
        contact_name: "Bradley Beal",
        contact_phone: "1-741-620-5747",
        credit_accepted: true})
    vendor2 = Vendor.create!({
        id: 102, 
        name: "Vettriano", 
        description: "I want to go home.", 
        contact_name: "Kyle Lowry", 
        contact_phone: "1-845-788-5064 x0918", 
        credit_accepted: false})
    
    get "/api/v0/vendors/#{vendor1.id}"

    vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(vendor).to be_a(Hash)
    expect(vendor).to have_key(:data)
    expect(vendor[:data]).to be_an(Hash)
    expect(vendor[:data]).to_not include(vendor2)

    expect(vendor[:data]).to have_key(:id)
    expect(vendor[:data][:id]).to be_an(String)
    expect(vendor[:data][:id]).to eq(vendor1.id.to_s)
    expect(vendor[:data][:id]).to_not eq(vendor2.id.to_s)

    expect(vendor[:data]).to have_key(:attributes)
    expect(vendor[:data][:attributes]).to be_an(Hash)
    expect(vendor[:data][:attributes]).to_not include(vendor2)

    expect(vendor[:data][:attributes]).to have_key(:name)
    expect(vendor[:data][:attributes][:name]).to be_a(String)
    expect(vendor[:data][:attributes][:name]).to eq(vendor1.name)

    expect(vendor[:data][:attributes]).to have_key(:description)
    expect(vendor[:data][:attributes][:description]).to be_a(String)
    expect(vendor[:data][:attributes][:description]).to eq(vendor1.description)
    
    expect(vendor[:data][:attributes]).to have_key(:contact_name)
    expect(vendor[:data][:attributes][:contact_name]).to be_a(String)
    expect(vendor[:data][:attributes][:contact_name]).to eq(vendor1.contact_name)

    expect(vendor[:data][:attributes]).to have_key(:contact_phone)
    expect(vendor[:data][:attributes][:contact_phone]).to be_a(String)
    expect(vendor[:data][:attributes][:contact_phone]).to eq(vendor1.contact_phone)
    
    expect(vendor[:data][:attributes]).to have_key(:credit_accepted)
    expect(vendor[:data][:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    expect(vendor[:data][:attributes][:credit_accepted]).to eq(vendor1.credit_accepted)
  end

  it "can create a new vendor" do
    vendor_params = ({
      name: "Seurat",
      description: "Hurrah for anarchy! This is the happiest moment of my life.",
      contact_name: "Bradley Beal",
      contact_phone: "1-741-620-5747",
      credit_accepted: true
      })    
    
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    created_vendor = Vendor.last

    expect(response).to be_successful
    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it 'sad path: cannot create a new vendor without all fields' do
    vendor_params = ({   
      name: "Seurat",
      })    

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    
    expect(response.status).to eq(400)
    expect(response).to_not be_successful
  end
end