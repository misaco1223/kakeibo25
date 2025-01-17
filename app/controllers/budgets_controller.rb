class BudgetsController < ApplicationController
  def show
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
    @category = @budget.category
    @payments = @budget.payments.order(date: :asc)
    @total_amount = Budget.total_amount(@payments)
    @status = Budget.status(@budget, @payments)
    @remaining_amount = Budget.remaining_amount(@budget, @payments)
  end

  def new
    @money_file = MoneyFile.find(params[:money_file_id])
    @budget = @money_file.budgets.new
    @categories = current_user.categories
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

  def edit
    @budget = Budget.find(params[:id])
    @money_file = @budget.money_file
  end

  def update
    @budget = Budget.find(params[:id])
    if @budget.update(budget_params)
      redirect_to money_file_path(@budget.money_file), notice: "予算が正常に更新されました。"
      Rails.logger.info "Money File was successfully updated."  
    else
      render :edit, status: :unprocessable_entity
      Rails.logger.info "Money File was not updated."
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
    params.require(:budget).permit(:amount, :description, :money_file_id, :category_id)
  end
end