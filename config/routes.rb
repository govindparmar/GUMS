Rails.application.routes.draw do
  root 'basic_pages#home'
  
  get 'basic_pages/home'
  get 'basic_pages/help'
  get 'basic_pages/about'

  get 'sessions/new'
  
  get 'users/new'
  get 'users/:id/info' => 'users#info'
  get '/signup.html' => 'users#new'

  get 'users/:id/adminedit' => 'users#adminedit'
  get 'users/adminaddnew' => 'users#adminaddnew'
  post 'users/adminaddnew' => 'users#adminsavenew'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  
  get '/users/:id/copyuser' => 'users#copyuser'
  patch '/users/:id/copyuser' => 'users#docopyuser'
  post '/users/:id/copyuser' => 'users#docopyuser'
  
  get '/users/:id/moveuser' => 'users#moveuser'
  patch '/users/:id/moveuser' => 'users#domoveuser'
  post '/users/:id/moveuser' => 'users#domoveuser'
  
  
  resources :users 
  resources :sessions
  resources :organizations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
