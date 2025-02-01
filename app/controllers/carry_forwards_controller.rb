class CarryForwardsController < ApplicationController
  def index
    @money_files = current_user.money_files

    @money_files_with_data = @money_files.map do |money_file|
      current_month = Date.today.beginning_of_month
      previous_month = current_month.prev_month # 前月を取得

      budgets = Budget.where("year_month < ?", previous_month).where(money_file_id: money_file.id).includes(:category)

      # 予算データを取得
      budgets_with_data = budgets.map do |budget|
        payments = Payment.where(budget_id: budget.id)
        total_amount = payments.sum(&:amount) # その予算の支出合計
        remaining_amount = budget.amount - total_amount  # 残金計算
        category_name = budget.category&.name || "未設定"
        {
            budget: budget,                # 予算データ
            total_amount: total_amount,    # 支出合計
            remaining_amount: remaining_amount, # 残金
            category_name: category_name, # カテゴリー
            year_month: budget.year_month
        }
      end

      carry_forward = budgets_with_data.sum { |budget| budget[:remaining_amount] }
      {
        id: money_file.id,
        title: money_file.title,
        carry_forward: carry_forward,
        budgets: budgets_with_data
      }
    end
  end
end