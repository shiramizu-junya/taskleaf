class Task < ApplicationRecord
  # 登録、削除、更新などイベントの前後に任意の処理を挟むことを「コールバック」という。あるべきタイミングが来たらこの処理を実行するという感じ。
  # なので、バリデーションをする前に「set_nameless_name」を実行する
  # before_validation :set_nameless_name

  # バリデーション(検証)用のメソッドを「validate」というクラスメソッドに渡して、検証用のメソッドとして登録する
  validate :validate_name_not_including_comma

  # バリデーションチェック（必須入力）
  validates :name, presence: true
  # バリデーションチェック（30文字以上はエラー）
  validates :name, length: { maximum:30 }

  # 「関連」というDB上の紐付けを前提にモデルクラス同士を紐ずける。
  # UserモデルとTaksモデルは「１対多数」なので、多数の方に「belong_to:１のモデル名」を指定
  # belong_toはTaskクラスがUserクラスに依存しており、Userクラスのidを外部キーとして抱えていることを表す
  # Taskクラスのインスタンスに対して、「task.user」メソッドで紐付いたUserオブジェクト（そのタスクを登録したユーザーの情報）を取得できる
  belongs_to :user

  # Taskモデルのオブジェクトの外部から呼べないようにする
  private

  # 自分でバリデーションコードを書く(バリデーションのヘルパーメソッドを使わない)
  # nameにカンマが含まれていれば、errorsにエラーメッセージを格納する
  # nameオブジェクトがnilの場合、例外が発生するので、例外が発生するのを避けるためにぼっち演算子(&)を利用している
  # nameがnillの場合は「presence: true」に引っかかるので、そこでエラーにする
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマは含めることはできません') if name&.include?(',')
  end

  # nameオブジェクトの値が「nil または 空白」なら、文字列を代入(値の正規化)
  # def set_nameless_name
  #   self.name = '名前なし' if name.blank?
  # end

  # scopeを使う
  # scopeは絞り込み条件のメソッドをいろんなとこで使う場合にまとめて名前をつけて、カスタマイズしたクエリー用のメソッドとして使うことができる。
  # scopeを使えば繰り返し利用される絞り込み条件のメソッドをスッキリと書くことができる。
  scope :recent, -> { order(created_at: :desc) }

end
