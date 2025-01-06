class AddColumnToPaymentData < ActiveRecord::Migration[7.2]
  def change
    add_reference :payment_data, :payment_method, null: true, foreign_key: true
    add_reference :payment_data, :shop, null: true, foreign_key: true
    add_column :payment_data, :title, :string, null: true
    add_column :payment_data, :date, :datetime, null: true
    PaymentDatum.update_all(date: Time.zone.now, payment_method_id: 1)
    change_column_null :payment_data, :payment_method_id, false
    change_column_null :payment_data, :date, false
  end
end
