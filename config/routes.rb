Rails.application.routes.draw do
  devise_for :users
  root to: "messages#index"
  resources :users, only: [:edit, :update]
  resources :rooms, only: [:new, :create]
  #resourcesとonlyで都度必要なアクションを増やしていく方がミスがなくやりやすい。
end
