class Category < ApplicationRecord
  has_one :budget
  has_many :payment_data_categories
  has_many :payment_data, through: :payment_datum_categories
end
