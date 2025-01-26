# app/controllers/contacts_controller.rb
class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      # メール送信
      ContactMailer.inquiry_email(@contact).deliver_now

      # 完了画面へリダイレクト
      flash[:success] = 'お問い合わせ内容を送信しました。'
      redirect_to money_files_path
    else
      # 入力にエラーがあれば再描画
      flash.now[:error] = '入力内容にエラーがあります。'
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
