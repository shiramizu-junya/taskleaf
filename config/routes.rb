Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # namespace :adminの中に書いているので、/admin/users/new のように /admin から始まるようになる。
  # ヘルパーメソッドも「admin_」がつくようになる
  namespace :admin do
    resources :users
  end
  # http://localhost:3000 にアクセスした時はタスク一覧を表示する
  root to: 'tasks#index'
  # resorce :コントローラー名 でCRUDのルーティングを一括で設定
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
