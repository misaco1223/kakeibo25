class MoneyFilesController < ApplicationController
  before_action :require_login
  def index
    @money_files = current_user.money_files
  end

  def show
    @money_file = MoneyFile.find(params[:id])
    @budgets = @money_file.budgets
    @budgets_with_data = @budgets.map do |budget|
      payments = Payment.where(budget_id: budget.id)
      total_amount = payments.sum(&:amount) # その予算の支出合計
      remaining_amount = budget.amount - total_amount  # 残金計算
      category = budget.categories.pluck(:name).first
      {
        budget: budget,                # 予算データ
        total_amount: total_amount,    # 支出合計
        remaining_amount: remaining_amount, # 残金
        category: category
      }
    end
  end

  def new
    @money_file = MoneyFile.new
  end

  def create
   @money_file = current_user.money_files.build(money_file_params)
    if @money_file.save
      redirect_to money_files_path, notice: "家計簿が作成されました。"
      Rails.logger.info "Money File was successfully created."
    else
      render :new, status: :unprocessable_entity
      Rails.logger.info "Money File was not created."
    end
  end

  def destroy
    @money_file = MoneyFile.find(params[:id])
    @money_file.destroy
    redirect_to money_files_path, notice: "家計簿を削除しました"
  end

  private

  def money_file_params
    params.require(:money_file).permit(:title, :description)
  end
end
