class Category < ApplicationRecord
  has_many :budget_categories, dependent: :destroy
  has_many :budgets, through: :budget_categories
  belongs_to :user
  validates :name, presence: true
end