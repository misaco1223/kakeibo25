class CreatePaymentShops < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_shops do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.timestamps
    end
  end
end
