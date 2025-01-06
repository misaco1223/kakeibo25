class PaymentDataController < ApplicationController
  def show
    @budget = Budget.find(params[:id])
    @payments = @budget.payment_data.includes(:budget,:shop, :payment_method)
    @total_amount = PaymentDatum.total_amount(@payments)
    @remaining_amount = @budget.amount - @total_amount
    @status = PaymentDatum.status(@remaining_amount)
  end
end