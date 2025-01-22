class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :destroy]
  def new
    @user =User.new
  end
  
 def create
   user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation, :agree_to_terms)
   user_params[:agree_to_terms] = ActiveRecord::Type::Boolean.new.cast(user_params[:agree_to_terms])
   @user = User.new(user_params)
   if @user.save
    session[:user_id] = @user.id  # ユーザーIDをセッションに保存
    redirect_to money_files_path(@user), success: "アカウントを作成しました"
   else
    Rails.logger.debug("User creation failed: #{@user.errors.full_messages.join(', ')}")
   end
 end

 def show
    @user = User.find(params[:id])
 end

 def edit
    @user = User.find(params[:id])
 end

 def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), success: "アカウント情報を更新しました"
    end
 end
 def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to login_path, notice: "アカウントを削除しました"
 end

 private

 def user_params
    params.require(:user).permit(:name, :email, :password, :agree_to_terms, :password_confirmation)
 end
end
