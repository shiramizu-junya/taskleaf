# テストの前提となるデータ(テンプレート)を作成する
# テスト用のusersテーブルのカラムに書くデータを入れる
FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test1@example.com' }
    password { 'password' }
  end
end