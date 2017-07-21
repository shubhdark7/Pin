Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root "pins#index"
    end
    unauthenticated :user do
      root to: "devise/sessions#new"
    end
  end

  resources :pins, except: [:edit, :update, :new] do
    member do
      put 'like', to: 'pins#upvote'
    end
  end
  post 'add_pin', to: 'pins#add_pin'
  get 'boards/:id/pin/new', to: 'pins#new', as: :new_pin

  resources :boards

end
