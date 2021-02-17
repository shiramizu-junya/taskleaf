class User < ApplicationRecord
  # 「bcrypt」というgemのメソッドが「has_secure_password」
  # has_secure_passwordを使う場合は、テーブルのカラム名は「password_digest」にする
  # ユーザーが入力したパスワードは「has_secure_password」メソッドによって暗号化（ハッシュ化）されてカラムに保存される
  # ハッシュかされたパスワードは不可逆的な変換なので元に戻すことはできない
  # しかし、同じパスワードからは同じハッシュ化したパスワードが生成されるので、ログインする際にパスワードが一致しているかどうかの判定に使える。
  # またDBに不正アクセスされてパスワードが盗まれても無意味で、不可逆的なので安心
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # 「関連」というDB上の紐付けを前提にモデルクラス同士を紐ずける。
  # UserモデルとTaksモデルは「１対多数」なので、1の方に「has_many :多数のモデル名」を指定
  # has_manyはUserクラスのidカラムを、外部キーとして持つTaskクラスがあり、Userクラスのidカラムを複数登録可能であることを表す。
  # こうすると、Userクラスのインスタンスに対して「user.tasks」メソッドで紐付いたTaskオブジェクトの一覧（ユーザーが登録したタスクの一覧）を取得できる
  has_many :tasks
end
