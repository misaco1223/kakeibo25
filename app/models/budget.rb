class Budget < ApplicationRecord
  belongs_to :money_file
  belongs_to :category
  validates_uniqueness_of :category_id
end
