class CreatePaymentData < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_data do |t|
      t.references :money_file, null: false, foreign_key: true
      t.integer :amount, null: false
      t.text :description
      t.timestamps
    end
  end
end
