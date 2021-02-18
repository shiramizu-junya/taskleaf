# Adminというモジュール（名前空間）のなかの「UsersController」という意味
class Admin::UsersController < ApplicationController
  # ユーザーを操作する系のアクションが実行される前に「require_admin」メソッドを実行する
  before_action :require_admin

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を削除しました。"
  end

  private

  # StrongParamerters
  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  # 管理者権限ない人はリダイレクトする
  def require_admin
    redirect_to root_url unless current_user.admin?
  end
end
