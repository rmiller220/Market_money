class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find_by_id(params[:market_id])

    if market.nil?
      render json:  {
        "errors": [
              {
                "detail": "Couldn't find Market with 'id'=#{params[:market_id]}"
              }
          ]
      }, status: 404
    else 
    render json: VendorSerializer.new(market.vendors)
    end
  end

  def show
    vendor = Vendor.find_by_id(params[:id])
    if vendor.nil?
      render json:  {
        "errors": [
              {
                "detail": "Couldn't find Market with 'id'=#{params[:id]}"
              }
          ]
      }, status: 404
    else 
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    end
  end

  def create
    if vendor_params[:name].nil? || vendor_params[:description].nil? || vendor_params[:contact_name].nil? || vendor_params[:contact_phone].nil? || vendor_params[:credit_accepted].nil?
      render json:  {
        "errors": [
              {
                "detail": "Must fill in all fields correctly"
              }
          ]
      }, status: 400
    else render json: VendorSerializer.new(Vendor.create(vendor_params)), status: 201
      
    end
  end


  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end