class Shop < ApplicationRecord
  has_many :payment_shops, dependent: :destroy
  has_many :payments, through: :payment_shop
  belongs_to :user
  validates :name, presence: true
end