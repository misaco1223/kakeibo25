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

  def guest_login
    # ゲストユーザーを検索するか、存在しない場合は作成する
    user = User.find_or_create_by!(email: "guest@example.com") do |guest_user|
      guest_user.password = SecureRandom.urlsafe_base64
      guest_user.name = "ゲストユーザー"
    end

    # ログイン処理を行う（Deviseを使用している場合の例）
    session[:user_id] = user.id
    redirect_to money_files_path, success: "ゲストユーザーとしてログインしました"
  end

  def destroy
    session[:user_id] = nil
    session[:year_month] = nil
    redirect_to login_path, success: "ログアウトしました"
  end
end
