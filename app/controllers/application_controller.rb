class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :logged_in?
  add_flash_types :success, :danger
  before_action :set_greeting
  before_action :set_money_files

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to login_path, alert: "ログインが必要です" unless logged_in?
  end

  private
  def set_greeting
    current_time = Time.now
    if (Time.parse("05:00")...Time.parse("10:00")).cover?(current_time)
      @greeting = "おはようございます!"
    elsif (Time.parse("10:00")...Time.parse("17:00")).cover?(current_time)
      @greeting = "こんにちは!"
    else
      @greeting = "こんばんは!"
    end
  end

  def set_money_files
    @money_files = current_user.money_files if current_user
  end
end
