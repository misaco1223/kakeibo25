class CarryForwardsController < ApplicationController
  def index
    @money_files = current_user.money_files
  
    # フィルタの開始・終了年月を取得（デフォルトは nil）
    start_year_month = params[:start_year_month]
    end_year_month = params[:end_year_month]
  
    @money_files_with_data = @money_files.map do |money_file|
      current_month = Date.today.beginning_of_month
      previous_month = current_month.prev_month # 前月を取得
  
      # 「いつからいつまで」の範囲指定を適用
      budgets = Budget.where(money_file_id: money_file.id).includes(:category)

      if start_year_month.present? && end_year_month.present?
        budgets = budgets.where(year_month: start_year_month..end_year_month)
      elsif start_year_month.present?
        budgets = budgets.where("year_month >= ?", start_year_month).where("year_month < ?", previous_month)
      elsif end_year_month.present?
        budgets = budgets.where("year_month <= ?", end_year_month)
      else
        # 何も選択されていない場合、前月以前のデータを取得
        budgets = budgets.where("year_month < ?", previous_month)
      end
  
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

      # 絞り込み後のデータが空の場合はスキップ
      next if budgets_with_data.empty?

      # 繰越金額を計算（予算の残金合計）
      carry_forward = budgets_with_data.sum { |budget| budget[:remaining_amount] }
      {
        id: money_file.id,
        title: money_file.title,
        carry_forward: carry_forward,
        budgets: budgets_with_data
      }
    end.compact
  end  
end