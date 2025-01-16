class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_path, notice: "既にログインしています。"
    end
  end

  def create
    # Sorceryの`authenticate`メソッドを利用
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to money_files_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "ログアウトしました"
  end
end
