Rails.application.routes.draw do
  root "collections#home"
  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create', as: 'log_in'
  delete 'logout', to: 'sessions#destroy'
  get 'password', to: 'passwords#edit', as: 'edit_password'
  patch 'password', to: 'passwords#update'
  get 'password/reset', to: 'password_resets#new'
  post 'password/reset', to: 'password_resets#create'
  get 'password/reset/edit', to: 'password_resets#edit'
  patch 'password/reset/edit', to: 'password_resets#update'

  get '/search_user', to: 'search#search_user'

  get '/accept_invitation/:id', to: 'invitations#accept_invitation'
  get '/refuse_invitation/:id', to: 'invitations#refuse_invitation'
  get '/delete_invitation/:id', to: 'invitations#delete_invitation'
  get '/index_invitations', to: 'invitations#index'
  
  get '/show_collections/:id', to: 'inv_collections#show_collections'
  get '/request_collection/:id', to: 'inv_collections#request_collection'
  get '/accept_collection_invitation/:id', to: 'inv_collections#accept_invitation'
  get '/refuse_collection_invitation/:id', to: 'inv_collections#refuse_invitation'
  get '/delete_collection_invitation/:id', to: 'inv_collections#delete_invitation'
  get '/collections_shared/:id', to: 'inv_collections#collections_shared'

  get '/home', to: 'collections#home'

  get '/index_notifications', to: 'notifications#index'
  get '/delete_notification/:id', to: 'notifications#delete_notification'
  get '/delete_all_notifications', to: 'notifications#delete_all_notifications'

  get '/destroy_user_admin/:id', to: 'users#destroy_user_admin'

  resources :collections do
    resources :tasks
  end

  resources :users do
    resources :collections
  end

end
