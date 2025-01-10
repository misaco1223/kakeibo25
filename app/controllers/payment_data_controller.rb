class PaymentDataController < ApplicationController
  def index
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget = Budget.find(params[:budget_id])
    @payments = @budget.payment_data.includes(:budget,:shop, :payment_method)
    @total_amount = PaymentDatum.total_amount(@payments)
    @remaining_amount = @budget.amount - @total_amount
    @status = PaymentDatum.status(@remaining_amount)
  end

  def new
    @payments = PaymentDatum.new
  end

  def create
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget = Budget.find(params[:budget_id])
    @payment = @budget.payment_data.build(payment_data_params)
    if @payment.save
      redirect_to money_file_budget_payment_data_path(@budget.money_file, @budget), notice: "支出が正常に登録されました。"
      Rails.logger.info "Money File was successfully created."
    else
      render :new, status: :unprocessable_entity
      Rails.logger.info "Money File was not created."
    end
  end

  private
  
  def payment_data_params
    params.require(:payment_datum).permit(:amount, :budget_id, :shop_id, :payment_method_id)
  end
end
