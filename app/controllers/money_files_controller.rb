class MoneyFilesController < ApplicationController

  def index
    @files = MoneyFile.includes(:user)
  end

  def new
    MoneyFile.new
  end

  def create
    @money_file =MoneyFile.find(params[:id])
    if @money_file.save
      Rails.logger.info "Money File was successfully created."
    else
      Rails.logger.info "Money File was not created."
    end
  end

  private

  def money_file_params
    params.require(:money_file).permit(:file_title, :description)
  end
end
