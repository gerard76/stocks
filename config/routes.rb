StockChart::Application.routes.draw do
  resources :quotes do
    get 'data', to: "quotes#show"
  end
  
  root to: "quotes#index"
end
