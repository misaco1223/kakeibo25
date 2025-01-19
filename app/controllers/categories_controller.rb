class CategoriesController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.where(user_id: current_user.id)
  end


  def show
    @category = Category.find(params[:id])
    money_files = current_user.money_files
    @budgets = Budget.where(money_file_id: money_files.ids, category_id: @category.id)
    @payments = Payment.where(budget_id: @budgets.ids).order(date: :asc)
    @total_amount = @payments.sum(&:amount)
  end

  def new
    Category.new
  end
    
  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to request.referer, success: "カテゴリーを登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to request.referer, success: "カテゴリーを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to categories_path, success: "カテゴリーを削除しました。"
    else
      redirect_to categories_path, danger: "カテゴリーを削除できません。"
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :user_id)
  end
end