class SessionsController < ApplicationController
  # SessionsControllerのアクションを使おうとしても、ApplicationControllerの「login_require」メソッドが実行されて無限ループになる
  # なので、SessionsControllerのアクションはログインしていなくても使えるように「skip_before_action」で親クラスのフィルタを通らないようにする
  skip_before_action :login_require
  # ログイン画面表示
  def new
  end

  # ログイン機能
  def create
    # {"email"=>"aaa@gmail.com", "password"=>"[FILTERED]"} の[:email]を取得する
    user = User.find_by(email: session_params[:email])

    # レシーバ（user）がnilだと例外が発生して止まるので、ぼっち演算子を使って例外を発生させない
    # authenticateメソッドはUserクラスにhas_secure_passwordを記述すると自動で追加された認証のメソッドです。
    # 引数で受け取ったパスワードをハッシュ化して、userオブジェクト内部に保存されているpassword_digestと一致するかを調べる。
    if user&.authenticate(session_params[:password])
      # セッションを使いログイン保持する。ログインしていなければ空、ログインしていればidが入っている。
      session[:user_id] = user.id
      redirect_to root_url, notice: 'ログインしました。'
    else
      render :new
    end
  end

  # ログアウト機能
  def destroy
    # セッションの情報を全て破棄
    reset_session
    redirect_to root_url, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
