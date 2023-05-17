Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only: [:create]
      delete "/market_vendors", to: "market_vendors#destroy"
      get "/markets/search", to: "markets#search"
      resources :markets, only: [:index, :show, :create, :update, :destroy] do
        resources :vendors, only: [:index]
      end
    end
  end
end
