class Api::V0::MarketVendorsController < ApplicationController
  # def index
  #   render json: MarketVendor.all
  # end

  # def show
  #   render json: MarketVendor.find(params[:id])
  # end

  def create
    vendor = Vendor.find_by_id(params[:vendor_id])
    market = Market.find_by_id(params[:market_id])
    market_vendor = MarketVendor.new(vendor: vendor, market: market)
    if market_vendor.save
      render json: MarketVendorSerializer.new(market_vendor), status:201
    else
      render json:  {
        "errors": [
          {
            "detail": "#{market_vendor.errors.full_messages.to_sentence}"
          }
        ]
      }, status: 400
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by_id(params[:id])
    
    if market_vendor.nil?
      render json: {
        "errors": [
          {
            "detail": "Couldn't find MarketVendor with 'id'=#{params[:id]}"
          }
        ]
      }
    else
      render json: MarketVendorSerializer.new(market_vendor), status: 200
    end
  end
end