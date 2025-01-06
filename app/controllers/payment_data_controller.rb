class PaymentDataController < ApplicationController
  def index
    @payments = PaymentDatum.where(budget_id: params[:id])
  end
end