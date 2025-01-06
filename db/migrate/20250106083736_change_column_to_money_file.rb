class ChangeColumnToMoneyFile < ActiveRecord::Migration[7.2]
  def change
    remove_column :money_files, :file_title
    add_column :money_files, :title, :string, null: true
    MoneyFile.update_all(title: "家計簿")
    change_column_null :money_files, :title, false
  end
end
