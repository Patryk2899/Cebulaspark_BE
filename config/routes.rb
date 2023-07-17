Rails.application.routes.draw do
  get '/current_user', to: 'current_user#index'

  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }
  post '/reset_password', to: 'users/passwords#create'
  put '/update_password', to: 'users/passwords#update'

  post '/bargains/create', to: 'bargain#create'
  put '/bargains/update', to: 'bargain#update'
  delete '/bargains/delete', to: 'bargain#destroy'

  get '/comments/:bargain_id', to: 'comments#show'
  post '/comments/create', to: 'comments#create'
  put '/comments/update', to: 'comments#update'
  delete '/comments/:id', to: 'comments#destroy'
end
