class Api::V0::MarketVendorsController < ApplicationController
  def index
    render json: MarketVendor.all
  end

  def show
    render json: MarketVendor.find(params[:id])
  end
end