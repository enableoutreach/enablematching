Rails.application.routes.draw do
  
  
  devise_for :members, controllers: {registrations: 'members/registrations'}
  devise_scope :member do
    root to: "devise/sessions#new"
    get "members/sign_out", :to => "devise/sessions#destroy"
    get "members/:id/edit", :to => "members/registrations#edit"
  end
    
  get '/requests/mine', to: 'requests#mine'
  post '/offers/accept', to: 'offers#accept'
  post '/offers/decline', to: 'offers#decline'

  resources :members
  resources :requests
  resources :offers
  resources :devices
  resources :messages

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
