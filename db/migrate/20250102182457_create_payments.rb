class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :budget, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :amount, null: false
      t.datetime :date, null: false
      t.references :shop, null:true, foreign_key:true
      t.references :pay_method, null:true, foreign_key:true
      t.timestamps
    end
  end
end
