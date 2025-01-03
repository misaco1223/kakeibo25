class AddCategoryToBudgets < ActiveRecord::Migration[7.2]
  def change
    add_reference :budgets, :category, null: true, foreign_key: true
  end
end
