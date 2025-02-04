class CategoriesController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.where(user_id: current_user.id)
  end


  def show
    @category = Category.find(params[:id])
    @budgets = Budget.where(category_id: @category.id)
    @payments = Payment.where(budget_id: @budgets.ids).order(date: :asc)
    @total_amount = @payments.sum(&:amount)

    # 支払い方法と店舗を取得
    @pay_methods = PayMethod.where(id: @payments.pluck(:pay_method_id)).distinct
    @shops = Shop.where(id: @payments.pluck(:shop_id)).distinct

    # フィルタリング
    if params[:year_month_filter].present?
      filtered_budgets = @budgets.where(year_month: params[:year_month_filter])
      @payments = Payment.where(budget_id: filtered_budgets.pluck(:id)).order(date: :asc)
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
    Category.new
  end
    
  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to request.referer, success: "カテゴリーを登録しました。"
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to request.referer, success: "カテゴリーを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to categories_path, success: "カテゴリーを削除しました。"
    else
      redirect_to categories_path, danger: "カテゴリーを削除できません。"
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :user_id)
  end
end