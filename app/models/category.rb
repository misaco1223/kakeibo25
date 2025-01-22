class Category < ApplicationRecord
  has_many :budgets
  belongs_to :user
  validates :name, presence: true
end