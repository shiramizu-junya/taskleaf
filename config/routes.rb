Rails.application.routes.draw do
  # http://localhost:3000 にアクセスした時はタスク一覧を表示する
  root to: 'tasks#index'
  # resorce コントローラー名 でCRUDnoルーティングを一括で設定
  resources :tasks
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
