class PaymentDatum < ApplicationRecord
  belongs_to :budget
  belongs_to :shop, optional: true
  belongs_to :payment_method

  def self.total_amount(payment_data)
    payment_data.sum(&:amount)
  end

  def self.status(remaining_amount)
    remaining_amount > 0 ? "黒字" : "赤字"
  end

  def self.remaining_amount(budget_amount, total_amount)
    return budget_amount - total_amount
  end
end
