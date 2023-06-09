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

  it 'sad path: returns 404 if vendor does not exist' do
    get "/api/v0/vendors/123123123123"

    vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
    expect(vendor[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
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
    vendor = JSON.parse(response.body, symbolize_names: true)
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
      name: "Seurat"
      })    

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

    vendor = JSON.parse(response.body, symbolize_names: true) 
    
    expect(response.status).to eq(400)
    expect(response).to_not be_successful
    expect(vendor[:errors][0][:detail]).to eq("Description can't be blank, Contact name can't be blank, Contact phone can't be blank, and Credit accepted is not included in the list")
  end

  it "can update an existing vendor" do
    vendor1 = Vendor.create!({
      name: "Seurat",
      description: "Hurrah for anarchy! This is the happiest moment of my life.",
      contact_name: "Bradley Beal",
      contact_phone: "1-741-620-5747",
      credit_accepted: true
      })    
    id = vendor1.id
    previous_name = Vendor.last.name
    previous_contact_name = Vendor.last.contact_name
    vendor_params = { 
      name: "Bob the Builder",
      description: "Hurrah for anarchy! This is the happiest moment of my life.",
      contact_name: "Bob Cousy",
      contact_phone: "1-741-620-5747",
      credit_accepted: true}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
    vendor_response = JSON.parse(response.body, symbolize_names: true)
    vendor = Vendor.find_by(id: id)

    expect(response).to be_successful
    expect(vendor.name).to_not eq(previous_name)
    expect(vendor.name).to eq("Bob the Builder")
    expect(vendor.description).to eq(vendor_params[:description])
    expect(vendor.contact_name).to_not eq(previous_contact_name)
    expect(vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it 'sad path: cannot update a vendor without all fields' do
    vendor1 = Vendor.create!({
      name: "Seurat",
      description: "Hurrah for anarchy! This is the happiest moment of my life.",
      contact_name: "Bradley Beal",
      contact_phone: "1-741-620-5747",
      credit_accepted: true
      })    
    id = vendor1.id

    vendor_params = { 
      name: ""}

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate({vendor: vendor_params})
    vendor_response = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(response).to_not be_successful
    expect(vendor_response[:errors][0][:detail]).to eq("Name can't be blank")
  end

  it "can delete an existing vendor" do
    vendor = Vendor.create!({
      name: "Seurat",
      description: "Hurrah for anarchy! This is the happiest moment of my life.",
      contact_name: "Bradley Beal",
      contact_phone: "1-741-620-5747",
      credit_accepted: true
      })    
    expect(Vendor.count).to eq(1)
    id = vendor.id

    delete "/api/v0/vendors/#{id}"

    expect(response).to be_successful
    expect(Vendor.count).to eq(0)
    expect{Vendor.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'sad path: cannot delete a vendor that does not exist' do
    delete "/api/v0/vendors/123123123123"

    vendor = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
    expect(vendor[:errors][0][:detail]).to eq("Could not find Vendor with 'id'=123123123123")
  end
end