class Api::V0::MarketsController < ApplicationController
  before_action :valid_search?, only: [:search]
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    market = Market.find_by_id(params[:id])

    if market.nil?
      render json:  {
        "errors": [
              {
                "detail": "Couldn't find Market with 'id'=#{params[:id]}"
              }
          ]
      }, status: 404
    else
      render json: MarketSerializer.new(Market.find(params[:id]))
    end
  end

  def search 
    markets = Market.search_markets(params[:state], params[:name], params[:city])
    render json: MarketSerializer.new(markets)
  end

  def nearest_atms
    market = Market.find_by_id(params[:id])
    if market.nil?
      require 'pry'; binding.pry
      render json:  {
        "errors": [
          {
            "detail": "Couldn't find Market with 'id'=#{params[:id]}"
          }
        ]
      }, status: 404
    else
      render json: AtmFacade.new(market).atm_details
    end
  end

  private
    def valid_search?
      if city? || name_city?
        render json: {"errors":
          [
            {
              "detail": "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
              }
              ]
              }, status: 422
      end
    end

    def city?
      params[:city].present? && !params[:name].present? && !params[:state].present?
    end

    def name_city?
      params[:city].present? && params[:name].present? && !params[:state].present?
    end
end