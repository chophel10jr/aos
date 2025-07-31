Rails.application.routes.draw do
  root to: 'home#show'

  # Sessions (login/logout)
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Resources
  resources :accounts, only: [:new, :create, :index, :update]
  get '/track-account', to: 'accounts#show_by_token'

  resources :users, only: [:new, :create, :index, :update, :edit, :destroy]

  # Webhooks
  post '/ndi_webhooks', to: 'ndi_webhooks#create'
  get '/check_webhook_status', to: 'ndi_webhooks#check_status'

  # Account-specific routes
  get '/accounts/proof_request', to: 'accounts#proof_request'
  post '/sync_account_with_obo', to: 'accounts#sync_account_with_obo'

  # Misc
  get '/track-application', to: 'home#track_application'

  get '/open-account', to: 'home#open_account'
  get '/fetch_status', to: 'ndi#fetch_status'
end
