class BudgetsController < ApplicationController
  before_action :require_login
  def index
    redirect_to money_files_path
  end

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
    # 月が送信されている場合、ゼロ埋めしてyear_monthに結合
    if params[:budget][:month].present?
      month = params[:budget][:month].rjust(2, '0')  # 1桁の場合、ゼロ埋め
      year_month = "#{params[:budget][:year_month]}-#{month}"
    else
      year_month = params[:budget][:year_month]
    end

    # quick_addをしようした場合に複数のBudgetオブジェクトを作成
    if params[:budget][:budget_ids].present? && params[:budget][:year_month].present? && params[:budget][:month].present?
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
        redirect_to money_file_path(@budget.money_file)
      else
        flash[:error] = "予算の作成に失敗しました。"
        render :quick_add, status: :unprocessable_entity
      end
    
    # quick_addで、月が指定されなかった場合
    elsif (params[:budget][:budget_ids].present? && params[:budget][:month].blank?) || (params[:budget][:year_month].present? && params[:budget][:year_month].blank?)
      Rails.logger.debug "パラメータは#{params[:budget]}"
      flash.now[:error] = "予算を登録する月を設定してください"
      @money_file = MoneyFile.find(params[:budget][:money_file_id])
      @budgets = Budget.where(money_file_id: @money_file.id).order(year_month: :desc)
      @budget_ids = params[:budget][:budget_ids]
      render :quick_add, status: :unprocessable_entity
  
    # newから新規作成する場合
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
        flash[:success] = "予算が作成されました。"
        redirect_to money_file_path(@budget.money_file)
      else
        flash.now[:error] = "入力内容を確認してください"
        @money_file = MoneyFile.find(@budget.money_file_id)
        @categories = current_user.categories
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
    @money_file = @budget.money_file
    @categories = current_user.categories.all

    # 許可するパラメータ
    budget_params = params.require(:budget).permit(:amount, :description, :money_file_id, :category_id, :category_name, :budget_image, :budget_image_cache, :remove_budget_image, :year_month)
    
    # 画像削除処理（budget_params の merge に統合）
    if params[:budget][:remove_budget_image] == "1"
      budget_params[:budget_image] = nil
    end

    # 予算のnew作成フォームで新しいカテゴリーを作成しているかどうか。
    if params[:budget][:category_name].present?
      category = current_user.categories.create!(name: params[:budget][:category_name])
      budget_params[:category_id] = category.id
    end

    # category_idをparamsから削除
    budget_params.delete(:category_name)

    Rails.logger.debug "budget_paramsは: #{budget_params.inspect}"

    if @budget.update(budget_params)
      redirect_to money_file_path(@money_file), success: "予算が更新されました。"
    else
      flash.now[:error] = "入力内容を確認してください"
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
    if @budget.destroy
      redirect_to money_file_path(@money_file), success: "予算が削除されました。"
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:amount, :description, :money_file_id, :category_id, :budget_image, :budget_image_cache, :remove_budget_image, :year_month, :month)
  end
end