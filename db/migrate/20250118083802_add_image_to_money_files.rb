class AddImageToMoneyFiles < ActiveRecord::Migration[7.2]
  def change
    add_column :money_files, :money_file_image, :string
  end
end
