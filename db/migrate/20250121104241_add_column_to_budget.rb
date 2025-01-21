class AddColumnToBudget < ActiveRecord::Migration[7.2]
  def change
    add_column :budgets, :year_month, :string
  end
end
