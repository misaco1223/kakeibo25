class CategoriesController < ApplicationController
  def index
    @categories = current_user.categories
  end

  def new
    Category.new
  end
    
  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to new_budget_path, notice: "カテゴリーを登録しました。"
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
      redirect_to categories_path, notice: "カテゴリーを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to categories_path, notice: "カテゴリーを削除しました。"
    else
      redirect_to categories_path, notice: "カテゴリーを削除できません。"
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :user_id)
  end
end