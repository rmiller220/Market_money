class Api::V0::MarketVendorsController < ApplicationController

  def create
    vendor = Vendor.find_by_id(params[:vendor_id])
    market = Market.find_by_id(params[:market_id])
    market_vendor = MarketVendor.new(vendor: vendor, market: market)

    if market_vendor.save
      render json: MarketVendorSerializer.new(market_vendor), status:201
    elsif vendor.nil? || market.nil?
      render json:  {
        "errors": [
          {
            "detail": "#{market_vendor.errors.full_messages.to_sentence}"
          }
        ]
      }, status: 400
      else
        render json:  {
          "errors": [
            {
              "detail": "Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists"
            }
          ]
        }, status: 422
    end
  end

  def destroy
    market = Market.find_by_id(params[:market_id])
    vendor = Vendor.find_by_id(params[:vendor_id])
    market_vendor = MarketVendor.find_market_vendor(market.id, vendor.id)

    if market_vendor.nil?
      render json: {
        "errors": [
          {
            "detail": "No market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} exists"
          }
        ]
      }, status: 404
    else
      render json: MarketVendorSerializer.new(MarketVendor.destroy(market_vendor.id)), status: 204
    end
  end
end