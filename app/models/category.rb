class Category < ApplicationRecord
  has_many :budget_categories
  has_many :budgets, through: :budget_categories
  has_many :payment_data_categories
  has_many :payment_data, through: :payment_datum_categories
end
