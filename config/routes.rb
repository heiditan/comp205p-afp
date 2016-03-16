Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, :controllers => { :registrations => 'user_registrations' }
  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'no_search' => 'static_pages#no_search'
  devise_scope:user do
  	get 'provider/sign_up' => 'user_registrations#new', :user => { :user_type => 'provider' }
  	get 'sme/sign_up' => 'user_registrations#new', :user => { :user_type => 'sme' }
  	get 'all_users' => 'users#index'
    get 'users/:id' => 'users#show', as: 'profile'
    get 'users/:id/edit_settings' => 'users#edit_settings', as:'edit_settings'
    patch 'users/:id/edit_settings' => 'users#update_settings'
    get 'users/:id/sme_edit' => 'users#sme_edit', as: 'sme_edit'
    patch 'users/:id/sme_edit' => 'users#sme_update'
    get 'users/:id/provider_edit' => 'users#provider_edit', as: 'provider_edit'
    patch 'users/:id/provider_edit' => 'users#provider_update'
  end
end