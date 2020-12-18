Rails.application.routes.draw do
  devise_for :users
  root to: "rooms#index"
  resources :users, only: [:edit, :update]
  resources :rooms, only: [:new, :create, :show, :destroy] do
    resources :messages, only: [:index, :create]
    #特定のどこかの中（今回の場合特定のroom）で行われる処理のルーティングは、以上のようにネストを使用するのが良い。
    #親（rooms）に属する子（messages）という明示の仕方
    #チャットルームに属するメッセージ
  end
  #resourcesとonlyで都度必要なアクションを増やしていく方がミスがなくやりやすい。
end
