class PaymentMethod < ApplicationRecord
  has_many :payment_data_payment_methods
  has_many :payment_data, through: :payment_data_payment_methods
end
