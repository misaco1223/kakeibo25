class CreateMoneyFiles < ActiveRecord::Migration[7.2]
  def change
    create_table :money_files do |t|
      t.string :file_title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
