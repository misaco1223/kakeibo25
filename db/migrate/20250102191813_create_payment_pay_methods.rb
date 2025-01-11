class CreatePaymentPayMethods < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_pay_methods do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :pay_method, null: false, foreign_key: true
      t.timestamps
    end
  end
end
