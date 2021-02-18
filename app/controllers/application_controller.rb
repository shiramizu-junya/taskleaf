class ApplicationController < ActionController::Base
  # ビューファイルからも使えるようにヘルパーメソッドとして登録する
  helper_method :current_user
  # フィルタとしてメソッドを登録
  # 「フィルタ」という、アクションを処理する前に任意の処理を挟むことができる
  # アクションを実行する前にリダイレクトして、アクションに到達しないようにする。なので特定の状況の時だけアクションが利用できるように制限する目的に使う。
  before_action :login_require

  # 「フィルタ」を使って複数の言語(locals.rb、ja.yml)を切り替えて利用できるようにする(ユーザーごとに利用言語を設定する)
  # before_action :set_locale

  private

  # ユーザーがログインしていればセッションにユーザーIDが格納されているの、それを使ってログインしているユーザーん情報を取得する
  # ログインしているユーザーの情報を取得するメソッドはいろんなところ（コントローラー、ビュー）で使うので、共通のコントローラーにまとめる
  # findメソッドで検索すると、nilを渡した時にエラーになる。セッションが消えている時に例外が発生しないようfind_byを使う。
  # @current_user || @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ログインしていない場合はログイン画面にリダイレクトする
  def login_require
    redirect_to login_url unless current_user
  end

  # 国際化（ユーザー選んだ言語ごとに切り替える）
  # usersテーブルにlocaleというカラムを用意して、ログインしているユーザーのlocaleカラムの値を取得する。
  # def set_locale
  #   I18n.locale = current_user&.locale || :ja
  # end
end
