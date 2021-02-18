# userは「users.rb」の「:user」という名前のFactory(テストテンプレート)をTaskモデルの定義されたuserという名前を関連づけて利用する。という意味。
FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'Rspec & Capybara & FactoryBotを準備する' }
    user
  end
end