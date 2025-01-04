class PaymentDataController < ApplicationController
  def index
    @payments = PaymentDatum.includes(:money_file)
  end
end