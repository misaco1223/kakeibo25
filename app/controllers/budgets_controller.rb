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
    Rails.logger.info "Categories: #{@categories.inspect}" 
  end

  def create
    # 月が送信されている場合、ゼロ埋めしてyear_monthに結合
    if params[:budget][:month].present?
      month = params[:budget][:month].rjust(2, '0')  # 1桁の場合、ゼロ埋め
      year_month = "#{params[:budget][:year_month]}-#{month}"
    else
      year_month = params[:budget][:year_month]
    end

    # 新しいBudgetオブジェクトを作成
    if params[:budget][:budget_ids].present?
      budget_ids = Array(params[:budget][:budget_ids])
      Rails.logger.debug "選択された予算idは: #{budget_ids.inspect}" 
      success_count = 0

      # quick_addで選択された予算のデータを使って、新しい予算を作成し、カウントする
      budget_ids.each do |budget_id|
        old_budget = Budget.find(budget_id)
        @budget = Budget.new(
          amount: old_budget.amount,
          category_id: old_budget.category_id,
          budget_image: old_budget.budget_image,
          year_month: year_month,
          money_file_id: params[:budget][:money_file_id]
        )
        if @budget.save
          success_count += 1
        end
      end

      # 成功件数を表示
      if success_count > 0
        flash[:success] = "#{success_count} 件の予算が作成されました。"
      end
      redirect_to money_file_path(@budget.money_file)
  
    else

      # monthを許可するように追加
      budget_params = params.require(:budget).permit(:amount, :description, :money_file_id, :category_id, :budget_image, :budget_image_cache, :remove_budget_image, :year_month)

      # 予算のnew作成フォームで新しいカテゴリーを作成しているかどうか。
      if budget_params[:category_id].blank? && params[:budget][:category_name].present?
        category = current_user.categories.create!(name: params[:budget][:category_name])
        budget_params[:category_id] = category.id  # ここで更新
      end

      # 新しいBudgetオブジェクトを作成
      @budget = Budget.new(budget_params.merge(year_month: year_month))

      if @budget.save
        redirect_to money_file_path(@budget.money_file), success: "予算が作成されました。"
      else
        flash.now[:danger] = "予算を登録できません。"
        render :new, status: :unprocessable_entity
      end
    end
  end

  def quick_add
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget = @money_file.budgets.new
    @budgets = Budget.where(money_file_id: @money_file.id).order(year_month: :desc)
    @categories = current_user.categories
  end

  def edit
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
    @categories = current_user.categories
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
    params.require(:budget).permit(:amount, :description, :money_file_id, :category_id, :budget_image, :budget_image_cache, :remove_budget_image, :year_month, :month)
  end
end