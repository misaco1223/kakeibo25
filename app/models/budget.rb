class Budget < ApplicationRecord
  belongs_to :money_file
  belongs_to :category
end
