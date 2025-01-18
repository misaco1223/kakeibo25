class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_path, success: "既にログインしています。"
    end
  end

  def create
    # Sorceryの`authenticate`メソッドを利用
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to money_files_path, success: "ログインしました"
    else
      flash[:danger] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, success: "ログアウトしました"
  end
end
