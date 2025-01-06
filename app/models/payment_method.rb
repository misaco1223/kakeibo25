class PaymentMethod < ApplicationRecord
  has_many :payment_data
end
