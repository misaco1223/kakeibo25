class ShopsController < ApplicationController
    def index
      @shops = Shop.where(user_id: current_user.id)
      @shop = current_user.shops.new
    end
  
    def new
      @shop = Shop.new
    end
      
    def create
      @shop = current_user.shops.new(shop_params)
      if @shop.save
        redirect_to shops_path, success: "店舗を登録しました。"
      else
        flash.now[:danger] = "店舗を登録できません。"
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @shop = Shop.find(params[:id])
    end
  
    def update
      @shop = current_user.shops.find(params[:id])
      if @shop.update(shop_params)
        redirect_to shops_path, success: "店舗を更新しました。"
      else
        flash[:danger] = "店舗を更新できません。"
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @shop = Shop.find(params[:id])
      @shop.destroy
      redirect_to shops_path, notice: "店舗を削除しました。"
    end
  
    private
  
    def shop_params
      params.require(:shop).permit(:name, :user_id, :address, :tel)
    end
  end