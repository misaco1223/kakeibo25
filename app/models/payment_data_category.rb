class PaymentDataCategory < ApplicationRecord
  belongs_to :category
  belongs_to :payment_datum
end