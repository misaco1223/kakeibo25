class Budget < ApplicationRecord
  belongs_to :money_file
  has_many :budget_categories
  has_many :categories, through: :budget_categories
end
