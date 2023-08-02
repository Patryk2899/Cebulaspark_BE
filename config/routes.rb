Rails.application.routes.draw do
  devise_for :user, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_scope :user do
    post '/login', to: 'users/sessions#create'
    post '/logout', to: 'users/sessions#destroy'
    post '/signup', to: 'users/registrations#create'
  end

  get '/current_user', to: 'current_user#index'

  post '/reset_password', to: 'users/passwords#create'
  put '/update_password', to: 'users/passwords#update'

  post '/bargains/create', to: 'bargain#create'
  put '/bargains/update', to: 'bargain#update'
  delete '/bargains/delete', to: 'bargain#destroy'
  get '/bargains/show', to: 'bargain#show'
  get '/bargains', to: 'bargain#fetch'

  get '/comments/:bargain_id', to: 'comments#show'
  post '/comments/create', to: 'comments#create'
  put '/comments/update', to: 'comments#update'
  delete '/comments/:id', to: 'comments#destroy'

  put '/users/update_email', to: 'users/users#update_email'
  put '/users/update_password', to: 'users/users#update_password'
  post '/users/password_check', to: 'users/users#check_password'

  get '/categories', to: 'categories#fetch'

  post '/change/email', to: 'emails#update'
end
