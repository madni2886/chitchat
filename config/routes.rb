Rails.application.routes.draw do


  devise_for :user

  resources :user do
    resources :groups do
      resources :posts do

      resources :comments do
      end
      end
      get 'join', on: :member
      get 'show_request', on: :member
      get 'accept_request', on: :member
    end
  end
  resources :admin do
    resources :user do
      get 'change_plan', on: :member
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do

    get "login", to: "devise/sessions#new"
    get 'user/sign_up' ,to: "devise/registrations#new"
    get 'logout' => 'devise/sessions#destroy'

  end
  get "posts",to:"posts#show_posts"
  get "showUser", to: "admin#show_users"
  root 'groups#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
