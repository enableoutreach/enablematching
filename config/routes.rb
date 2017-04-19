Rails.application.routes.draw do
  
  
  
  devise_for :members, controllers: {registrations: 'members/registrations', sessions: 'members/sessions'}

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
  
  devise_scope :chapter do
    get 'chapters/:id/claim', to: 'chapters#claim'
    get 'chapters/:id/claimsend', to: 'chapters#claimsend'
    get 'chapters/agree', to: 'chapters#agree'
    get 'chapters/:id/review', to: 'chapters#review'
    post 'chapters/:id/approve', to: 'chapters#approve'
    post 'chapters/:id/reject', to: 'chapters#reject'
  end


  resources :members
  resources :requests
  resources :offers
  resources :devices
  resources :messages
  resources :chapters
  resources :notices

  get 'states/:country', to: 'application#states'
  get 'cities/:state', to: 'application#cities'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
