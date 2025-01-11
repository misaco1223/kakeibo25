class PayMethod < ApplicationRecord
  has_many :payment_pay_methods, dependent: :destroy
  has_many :payments, through: :payment_pay_methods
  belongs_to :user
  validates :name, presence: true

  
end