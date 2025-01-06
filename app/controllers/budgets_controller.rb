class BudgetsController < ApplicationController

  def show
    @money_file = MoneyFile.includes(:budgets).find(params[:id])
    @budgets = @money_file.budgets.includes(:category, :payment_data)

    @budgets_with_data = @budgets.map do |budget|
      total_amount = budget.payment_data.sum(&:amount) # その予算の支出合計
      remaining_amount = budget.amount - total_amount  # 残金計算
      {
        budget: budget,                # 予算データ
        total_amount: total_amount,    # 支出合計
        remaining_amount: remaining_amount # 残金
      }
    end
  end
  

  def new
    Budget.new
  end

  def create
    @budget =Budget.find(params[:id])
    if @budget.save
      Rails.logger.info "Money File was successfully created."
    else
      Rails.logger.info "Money File was not created."
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:amount, :category_id)
  end
end