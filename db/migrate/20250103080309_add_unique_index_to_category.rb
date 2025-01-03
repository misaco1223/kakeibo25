class AddUniqueIndexToCategory < ActiveRecord::Migration[7.2]
  def change
    add_index :categories, :name, unique: true
  end
end
