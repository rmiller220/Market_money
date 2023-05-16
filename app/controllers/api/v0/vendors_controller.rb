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
                "detail": "Couldn't find Vendor with 'id'=#{params[:id]}"
              }
          ]
      }, status: 404
    else 
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    end
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save 
      render json: VendorSerializer.new(Vendor.create(vendor_params)), status: 201
      
    else 
      render json:  {
        "errors": [
              {
                "detail": "#{vendor.errors.full_messages.to_sentence}"
              }
          ]
      }, status: 400
      
    end
  end

  def update
    vendor = Vendor.find_by_id(params[:id])
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(Vendor.update(params[:id], vendor_params)), status: 200
    else
      render json:  {
        "errors": [
              {
                "detail": "#{vendor.errors.full_messages.to_sentence}"
              }
          ]
      }, status: 400
    end
  end


  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end