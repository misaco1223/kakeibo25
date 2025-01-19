class PaymentsController < ApplicationController
  before_action :require_login
  def new
    @budget = Budget.find(params[:budget_id])
    @payment = @budget.payments.build
    @shops = current_user.shops
    @pay_methods = current_user.pay_methods
  end

  def create
    @budget = Budget.find_by(id: params[:budget_id])
    @payment = @budget.payments.build(payments_params)
    if @payment.save
      # shop_ids が存在する場合のみ関連付け
      shop_ids = params[:payment][:shop_ids]&.reject(&:blank?)
      @payment.shops << Shop.where(id: shop_ids) if shop_ids.present?

      # pay_method_ids が存在する場合のみ関連付け
      pay_method_ids = params[:payment][:pay_method_ids]&.reject(&:blank?)
      @payment.pay_methods << PayMethod.where(id: pay_method_ids) if pay_method_ids.present?

      redirect_to budget_path(@budget), success: "支払いデータが正常に登録されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @budget = Budget.find(params[:budget_id])
    @payment = @budget.payments.find(params[:id])
    @shop = current_user.shops
    @pay_method = current_user.pay_methods
  end

  def update
    @payment = Payment.find(params[:id])
    @budget = @payment.budget
    if @payment.update(payments_params)
      redirect_to budget_path(@budget), success: "支出が正常に更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget = Budget.find(params[:budget_id])
    @payment = @budget.payments.find(params[:id])
    @payment.destroy
    redirect_to budget_payments_path(@budget), notice: "支払いを削除しました。"

  end

  private
  
  def payments_params
    params.require(:payment).permit(:date, :title, :description, :amount, :shop_id, :pay_method_id)
  end
end
