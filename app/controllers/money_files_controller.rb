class MoneyFilesController < ApplicationController
  before_action :require_login
  def index
    @money_files = current_user.money_files
    @user = current_user
  end

  def show
    @money_file = MoneyFile.find(params[:id])
    @budgets = @money_file.budgets.includes(:category) 
    @budgets_with_data = @budgets.map do |budget|
      payments = Payment.where(budget_id: budget.id)
      total_amount = payments.sum(&:amount) # その予算の支出合計
      remaining_amount = budget.amount - total_amount  # 残金計算
      category_name = budget.category&.name || "未設定"
      {
        budget: budget,                # 予算データ
        total_amount: total_amount,    # 支出合計
        remaining_amount: remaining_amount, # 残金
        category_name: category_name # カテゴリー
      }
    end
  end

  def new
    @money_file = MoneyFile.new
  end

  def create
   @money_file = current_user.money_files.build(money_file_params)
    if @money_file.save
      redirect_to money_files_path, success: "家計簿が作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @money_file = MoneyFile.find(params[:id])
  end

  def update
    @money_file = MoneyFile.find(params[:id])

    # 画像削除チェックボックスの処理
    if params[:money_file][:remove_money_file_image] == "1"
      @money_file.remove_money_file_image!
    end

    if @money_file.update(money_file_params)
      redirect_to money_files_path, success: "家計簿が更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @money_file = MoneyFile.find(params[:id])
    @money_file.destroy
    redirect_to money_files_path, success: "家計簿を削除しました"
  end

  private

  def money_file_params
    params.require(:money_file).permit(:title, :description, :money_file_image, :money_file_cache, :remove_money_file_image)
  end
end
