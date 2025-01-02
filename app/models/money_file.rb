class MoneyFile < ApplicationRecord
  belongs_to :user
  validates :file_title, presence: true
  has_many :payment_data
  has_many :budgets
end
