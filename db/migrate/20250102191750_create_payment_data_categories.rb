class CreatePaymentDataCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_data_categories do |t|
      t.references :payment_datum, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
