class Payment < ApplicationRecord
  belongs_to :budget
  belongs_to :pay_method, optional: true
  belongs_to :shop, optional: true

  validates :date, presence: true
  validates :title, presence: true
  validates :amount, presence: true

  def money_file
    budget&.money_file
  end
end
