class MoneyFile < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  has_many :budgets
end
