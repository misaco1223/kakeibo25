class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    Category.new
  end
    
  def create
    @category = Category.find(params[:id])
    @category.save
  end
end