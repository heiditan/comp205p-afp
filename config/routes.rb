Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'user_registrations' }
  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'no_search' => 'static_pages#no_search'
  devise_scope:user do
  	get 'provider/sign_up' => 'user_registrations#new', :user => { :user_type => 'provider' }
  	get 'sme/sign_up' => 'user_registrations#new', :user => { :user_type => 'sme' }
  	get 'users' => 'users#index'
    get 'users/:id' => 'users#show', as: 'profile'
  end
end