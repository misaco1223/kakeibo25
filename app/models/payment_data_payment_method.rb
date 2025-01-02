class PaymentDataPaymentMethod < ApplicationRecord
  belongs_to :payment_method
  belongs_to :payment_datum
end
