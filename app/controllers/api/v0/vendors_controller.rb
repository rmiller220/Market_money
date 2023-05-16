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
    require 'pry'; binding.pry
    vendor = Vendor.find_by_id(params[:id])
# require 'pry'; binding.pry
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
    render json: VendorSerializer.new(Vendor.create(vendor_params))
    # if Vendor.save(vendor_params)

    # else
    #   render json:  {
    #     "errors": [
    #           {
    #             "detail": "Validation failed: Contact name can't be blank, Contact phone can't be blank"
    #           }
    #       ]
    #   }, status: 400
    # end
  end


  private
    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
    end
end