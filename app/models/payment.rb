class Payment < ApplicationRecord
  belongs_to :budget
  has_many :payment_pay_methods, dependent: :destroy
  has_many :pay_methods, through: :payment_pay_methods
  has_many :payment_shops, dependent: :destroy
  has_many :shops, through: :payment_shops
end
