class BudgetsController < ApplicationController
  def show
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
    @category = @budget.categories.pluck(:name).first
    @payments = @budget.payments
    @total_amount = Budget.total_amount(@payments)
    @status = Budget.status(@budget, @payments)
  end

  def new
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget = @money_file.budgets.new
  end

  def create
    @budget = Budget.new(budget_params)
    if @budget.save
      redirect_to money_file_path(@budget.money_file), notice: "予算が正常に作成されました。"
      Rails.logger.info "Money File was successfully created."
    else
      render :new, status: :unprocessable_entity
      Rails.logger.info "Money File was not created."
    end
  end


  def destroy
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
    @budget.destroy # dependent: :destroy で関連データも削除
    redirect_to money_file_path(@money_file), notice: "予算が削除されました"
  end

  private

  def budget_params
    params.require(:budget).permit(:amount, :description, :money_file_id, category_id: [])
  end
end