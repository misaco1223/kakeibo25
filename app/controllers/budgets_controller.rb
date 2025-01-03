class BudgetsController < ApplicationController

  def index
    @budgets = Budget.includes(:categories)
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