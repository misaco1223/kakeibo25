class PayMethodsController < ApplicationController
    def index
      @pay_methods = PayMethod.where(user_id: current_user.id)
      @pay_method = current_user.pay_methods.new
    end
  
    def new
      @pay_method = PayMethod.new
    end
      
    def create
      @pay_method = current_user.pay_methods.new(pay_method_params)
      if @pay_method.save
        redirect_to pay_methods_path, success: "支払い方法を登録しました。"
      else
        flash.now[:danger] = "支払い方法を登録できません。"
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @pay_method = PayMethod.find(params[:id])
    end
  
    def update
      @pay_method = current_user.pay_methods.find(params[:id])
      if @pay_method.update(pay_method_params)
        redirect_to pay_methods_path, success: "支払い方法を更新しました。"
      else
        flash.now[:danger] = "支払い方法を更新できません。"
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @pay_method= PayMethod.find(params[:id])
      @pay_method.destroy
      redirect_to pay_methods_path, notice: "支払い方法を削除しました。"
    end
  
    private
  
    def pay_method_params
      params.require(:pay_method).permit(:name, :user_id)
    end
  end