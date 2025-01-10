class MoneyFilesController < ApplicationController
  def index
    @files = MoneyFile.includes(:user)
  end

  def new
    @money_file = MoneyFile.new
  end

  def create
   current_user = User.find(2)
   @money_file = current_user.money_files.build(money_file_params)
    if @money_file.save
      redirect_to money_files_path, notice: "家計簿が作成されました。"
      Rails.logger.info "Money File was successfully created."
    else
      render :new, status: :unprocessable_entity
      Rails.logger.info "Money File was not created."
    end
  end

  private

  def money_file_params
    params.require(:money_file).permit(:title, :description)
  end
end
