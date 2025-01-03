class UsersController < ApplicationController
  def new
    User.new
  end
  
 def create
   @user = User.find(params[:id])
   @user.save
end
