class PaymentPayMethod < ApplicationRecord
  belongs_to :payment
  belongs_to :pay_method
end
