class PayMethodsController < ApplicationController
    before_action :require_login
    def index
      @pay_methods = PayMethod.where(user_id: current_user.id)
      @pay_method = current_user.pay_methods.new
    end
  
    def new
      @pay_method = PayMethod.new
    end

    def show
      @pay_method = PayMethod.find(params[:id])
      money_files = current_user.money_files
      @budgets = Budget.where(money_file_id: money_files.ids)
      @payments = Payment.where(budget_id: @budgets.ids, pay_method_id: @pay_method.id).order(date: :asc)
      @total_amount = @payments.sum(&:amount)

      # 店舗を取得
      @shops = Shop.where(id: @payments.pluck(:shop_id)).distinct

    # フィルタリング
    if params[:year_month_filter].present?
      filtered_budgets = @budgets.where(year_month: params[:year_month_filter])
      @payments = Payment.where(budget_id: filtered_budgets.pluck(:id)).order(date: :asc)
      @filtered_total_amount = Budget.total_amount(@payments)
    end

    if params[:shop_filter].present?
      @payments = @payments.where(shop_id: params[:shop_filter])
      @filtered_total_amount = Budget.total_amount(@payments)
    end
    end
      
    def create
      @pay_method = current_user.pay_methods.new(pay_method_params)
      if @pay_method.save
        redirect_to request.referer, success: "支払い方法を登録しました。"
      else
        flash.now[:danger] = "支払い方法を登録できません。"
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @pay_method = PayMethod.find(params[:id])
    end
  
    def update
      @pay_method = current_user.pay_methods.find(params[:id])
      if @pay_method.update(pay_method_params)
        redirect_to request.referer, success: "支払い方法を更新しました。"
      else
        flash.now[:danger] = "支払い方法を更新できません。"
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @pay_method= PayMethod.find(params[:id])
      begin
        @pay_method.destroy
        redirect_to pay_methods_path, notice: "支払い方法を削除しました。"
      rescue ActiveRecord::InvalidForeignKey => e
        flash.now[:error] = "支払いを削除できませんでした。関連するデータがあります。"
        redirect_to pay_method_path(@pay_method)
      end
    end
  
    private
  
    def pay_method_params
      params.require(:pay_method).permit(:name, :user_id)
    end
  end