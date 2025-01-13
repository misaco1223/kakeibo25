class Payment < ApplicationRecord
  belongs_to :budget
  belongs_to :pay_method, optional: true
  belongs_to :shop, optional: true
end
