class CreateMoneyFiles < ActiveRecord::Migration[7.2]
  def change
    create_table :money_files do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.timestamps
    end
  end
end
