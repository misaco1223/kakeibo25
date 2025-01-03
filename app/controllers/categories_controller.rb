class CategoriesController < ApplicationController
    def new
      Category.new
    end
    
   def create
     @category = Category.find(params[:id])
     @category.save
  end