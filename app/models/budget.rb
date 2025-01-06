class Budget < ApplicationRecord
  belongs_to :money_file
  belongs_to :category
  has_many :payment_data
  validates_uniqueness_of :category_id
end
