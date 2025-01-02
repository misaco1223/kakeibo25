class CreatePaymentDataPaymentMethods < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_data_payment_methods do |t|
      t.references :payment_datum, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.timestamps
    end
  end
end
