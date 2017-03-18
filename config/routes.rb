Rails.application.routes.draw do
  
  
  devise_for :members, controllers: {registrations: 'members/registrations'}
  devise_scope :member do
    root to: "devise/sessions#new"
    get "members/sign_out", to: 'devise/sessions#destroy'
    get "members/:id/edit", to: 'members/registrations#edit'
  end
    
  devise_scope :offer do
    post 'offers/:id/accept', to: 'offers#accept', as: 'offers_accept'
    post 'offers/:id/decline', to: 'offers#decline', as: 'offers_decline'
  end
    
  devise_scope :request do
    get 'requests/mine', to: 'requests#mine'
    get 'requests/:id/complete', to: 'requests#complete'
  end


  resources :members
  resources :requests
  resources :offers
  resources :devices
  resources :messages
  resources :chapters

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
