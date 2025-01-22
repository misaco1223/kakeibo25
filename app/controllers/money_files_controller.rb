class MoneyFilesController < ApplicationController
  before_action :require_login
  before_action :set_year_month, only: [:show, :change_month]
  def index
    @money_files = current_user.money_files
    @user = current_user

    current_time = Time.now
    if (Time.parse("05:00")...Time.parse("10:00")).cover?(current_time)
    @greeting = "おはようございます"
    elsif (Time.parse("10:00")...Time.parse("17:00")).cover?(current_time)
    @greeting = "こんにちは"
    else
    @greeting = "こんばんは"
    end
  end

  def show
    @money_file = MoneyFile.find(params[:id])
    @budgets = Budget.where(year_month: session[:year_month], money_file_id: @money_file.id).includes(:category)
    @budgets_with_data = @budgets.map do |budget|
      payments = Payment.where(budget_id: budget.id)
      total_amount = payments.sum(&:amount) # その予算の支出合計
      remaining_amount = budget.amount - total_amount  # 残金計算
      category_name = budget.category&.name || "未設定"
      {
        budget: budget,                # 予算データ
        total_amount: total_amount,    # 支出合計
        remaining_amount: remaining_amount, # 残金
        category_name: category_name # カテゴリー
      }
    end
  end

  def change_month
    current_month = session[:year_month].present? ? Date.strptime(session[:year_month], "%Y-%m") : Date.today
    new_month = case params[:direction]
                when "prev"
                  current_month.prev_month
                when "next"
                  current_month.next_month
                else
                  current_month
                end

    session[:year_month] = new_month.strftime("%Y-%m")
    redirect_to money_file_path(params[:money_file_id])
  end

  def new
    @money_file = MoneyFile.new
  end

  def create
   @money_file = current_user.money_files.build(money_file_params)
    if @money_file.save
      redirect_to money_files_path, success: "家計簿が作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @money_file = MoneyFile.find(params[:id])
  end

  def update
    @money_file = MoneyFile.find(params[:id])

    # 画像削除チェックボックスの処理
    if params[:money_file][:remove_money_file_image] == "1"
      @money_file.remove_money_file_image!
    end

    if @money_file.update(money_file_params)
      redirect_to money_files_path, success: "家計簿が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @money_file = MoneyFile.find(params[:id])
    @money_file.destroy
    redirect_to money_files_path, success: "家計簿を削除しました"
  end

  def timeline
    @budgets = Budget.where(money_file_id: MoneyFile.where(user_id: current_user.id).pluck(:id))
    @budget_ids = Budget.where(money_file_id: MoneyFile.where(user_id: current_user.id).pluck(:id)).pluck(:id)
    @payments = Payment.where(budget_id: @budget_ids).order(date: :asc).page(params[:page])
    @total_amount = @payments.sum(&:amount)
    @categories = Category.where(id: @budgets.pluck(:category_id)).distinct
    @pay_methods = PayMethod.where(id: @payments.pluck(:pay_method_id)).distinct
    @shops = Shop.where(id: @payments.pluck(:shop_id)).distinct
   
    # フィルタリング
    if params[:year_month_filter].present?
      filtered_budgets = @budgets.where(year_month: params[:year_month_filter])
      @payments = Payment.where(budget_id: filtered_budgets.pluck(:id)).order(date: :asc).page(params[:page])
      @filtered_total_amount = Budget.total_amount(@payments)
    end

    if params[:category_filter].present?
      filtered_budgets = @budgets.where(category_id: params[:category_filter])
      @payments = @payments.where(budget_id: filtered_budgets.pluck(:id)).order(date: :asc).page(params[:page])
      @filtered_total_amount = Budget.total_amount(@payments)
    end
  
    if params[:pay_method_filter].present?
      @payments = @payments.where(pay_method_id: params[:pay_method_filter]).order(date: :asc).page(params[:page])
      @filtered_total_amount = Budget.total_amount(@payments)
    end
  
    if params[:shop_filter].present?
      @payments = @payments.where(shop_id: params[:shop_filter]).order(date: :asc).page(params[:page])
      @filtered_total_amount = Budget.total_amount(@payments)
    end    
  end

  private

  def money_file_params
    params.require(:money_file).permit(:title, :description, :money_file_image, :money_file_cache, :remove_money_file_image)
  end

  def set_year_month
    session[:year_month] ||= Date.today.strftime("%Y-%m")
  end
end
