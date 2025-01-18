class Budget < ApplicationRecord
  mount_uploader :budget_image, BudgetImageUploader
  attr_accessor :remove_budget_image
  belongs_to :money_file
  has_many :payments, dependent: :destroy
  belongs_to :category, optional: true

  def self.total_amount(payments) # 支出合計
    payments.sum(&:amount)
  end

  def self.status(budget,payments) # ステータス
    remaining_amount(budget, payments) > 0 ? "黒字" : "赤字"
  end

  def self.remaining_amount(budget, payments) # 残金
    total_amount = total_amount(payments)
    return budget.amount - total_amount
  end
end
