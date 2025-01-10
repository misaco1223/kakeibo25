class BudgetsController < ApplicationController

  def index
    @money_file = MoneyFile.find(params[:money_file_id])
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
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget =Budget.new
  end

  def create
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget = @money_file.budgets.build(budget_params)
    if @budget.save
      redirect_to money_file_budgets_path(@money_file), notice: "予算が正常に作成されました。"
      Rails.logger.info "Money File was successfully created."
    else
      render :new, status: :unprocessable_entity
      Rails.logger.info "Money File was not created."
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:amount, :category_id, :description)
  end
end