class ChangeReferencesToPaymentData < ActiveRecord::Migration[7.2]
  def change
    remove_reference :payment_data, :money_file, foreign_key: true
    add_reference :payment_data, :budget, null: true, foreign_key: true
    PaymentDatum.update_all(budget_id: 13)
    change_column_null :payment_data, :budget_id, false
  end
end