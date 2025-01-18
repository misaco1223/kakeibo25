class CategoriesController < ApplicationController
  before_action :require_login

  def index
    @categories = Category.where(user_id: current_user.id)
  end

  def new
    Category.new
  end
    
  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to new_budget_path, success: "カテゴリーを登録しました。"
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
      redirect_to categories_path, success: "カテゴリーを更新しました。"
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