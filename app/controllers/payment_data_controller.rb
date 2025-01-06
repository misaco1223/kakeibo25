class PaymentDataController < ApplicationController
  def index
    @payments = PaymentDatum.where(budget_id: params[:budget_id]).includes(:budget,:shop, :payment_method)
  end
end