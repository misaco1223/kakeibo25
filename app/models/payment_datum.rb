class PaymentDatum < ApplicationRecord
  belongs_to :budget
  belongs_to :shop, optional: true
  belongs_to :payment_method
end
