class PaymentDatum < ApplicationRecord
  belongs_to :money_file
  has_many :payment_data_categories
  has_many :categories, through: :payment_data_categories
  has_many :payment_data_payment_methods
  has_many :payment_methods, through: :payment_data_payment_methods
end
