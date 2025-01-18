class BudgetsController < ApplicationController
  before_action :require_login
  def show
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
    @user = @money_file.user
    @category = @budget.category
    @payments = @budget.payments.order(date: :asc)
    @total_amount = Budget.total_amount(@payments)
    @status = Budget.status(@budget, @payments)
    @remaining_amount = Budget.remaining_amount(@budget, @payments)

    # 支払い方法と店舗を取得
    @pay_methods = PayMethod.where(id: @payments.pluck(:pay_method_id)).distinct
    @shops = Shop.where(id: @payments.pluck(:shop_id)).distinct

    # フィルタリング
    if params[:date_filter].present?
      @payments = @payments.where(date: params[:date_filter])
      @filtered_total_amount = Budget.total_amount(@payments)
    end

    if params[:pay_method_filter].present?
      @payments = @payments.where(pay_method_id: params[:pay_method_filter])
      @filtered_total_amount = Budget.total_amount(@payments)
    end

    if params[:shop_filter].present?
      @payments = @payments.where(shop_id: params[:shop_filter])
      @filtered_total_amount = Budget.total_amount(@payments)
    end
  end

  def new
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget = @money_file.budgets.new
    @categories = current_user.categories
  end

  def create
    @budget = Budget.new(budget_params)
    if @budget.save
      redirect_to money_file_path(@budget.money_file), success: "予算が作成されました。"
      Rails.logger.info "Money File was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
  end

  def update
    @budget = Budget.find(params[:id])

    # 画像削除チェックボックスの処理
    if params[:budget][:remove_budget_image] == "1"
      @budget.remove_budget_image!
    end

    if @budget.update(budget_params)
      redirect_to money_file_path(@budget.money_file), success: "予算が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
    @budget.destroy # dependent: :destroy で関連データも削除
    redirect_to money_file_path(@money_file), success: "予算が削除されました"
  end

  private

  def budget_params
    params.require(:budget).permit(:amount, :description, :money_file_id, :category_id, :budget_image, :budet_image_cache, :remove_budget_image)
  end
end