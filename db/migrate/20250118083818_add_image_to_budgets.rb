class AddImageToBudgets < ActiveRecord::Migration[7.2]
  def change
    add_column :budgets, :budget_image, :string
  end
end
