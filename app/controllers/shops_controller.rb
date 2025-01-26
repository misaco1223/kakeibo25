class ShopsController < ApplicationController
    before_action :require_login
    def index
      @shops = Shop.where(user_id: current_user.id)
      @shop = current_user.shops.new
    end

    def show
      @shop = Shop.find(params[:id])
      money_files = current_user.money_files
      @budgets = Budget.where(money_file_id: money_files.ids)
      @payments = Payment.where(budget_id: @budgets.ids, shop_id: @shop.id).order(date: :asc)
      @total_amount = @payments.sum(&:amount)

      # 店舗を取得
      @pay_methods = PayMethod.where(id: @payments.pluck(:pay_method_id)).distinct

      # フィルタリング
      if params[:yaer_month_filter].present?
        filtered_budgets = @budgets.where(year_month: params[:year_month_filter])
        @payments = Payment.where(budget_id: filtered_budgets.pluck(:id)).order(date: :asc)
        @filtered_total_amount = Budget.total_amount(@payments)
      end

      if params[:pay_method_filter].present?
        @payments = @payments.where(pay_method_id: params[:pay_method_filter])
        @filtered_total_amount = Budget.total_amount(@payments)
      end
    end
  
    def new
      @shop = Shop.new
    end
      
    def create
      @shop = current_user.shops.new(shop_params)
      if @shop.save
        redirect_to request.referer, success: "店舗を登録しました。"
      else
        flash.now[:danger] = "店舗を登録できません。"
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @shop = Shop.find(params[:id])
    end
  
    def update
      @shop = current_user.shops.find(params[:id])
      if @shop.update(shop_params)
        redirect_to request.referer, success: "店舗を更新しました。"
      else
        flash[:danger] = "店舗を更新できません。"
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @shop = Shop.find(params[:id])
      @shop.destroy
      redirect_to shops_path, notice: "店舗を削除しました。"
    end
  
    private
  
    def shop_params
      params.require(:shop).permit(:name, :user_id, :address, :tel)
    end
  end