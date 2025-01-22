class CreateShops < ActiveRecord::Migration[7.2]
  def change
    create_table :shops do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address
      t.string :tel
      t.timestamps
    end
  end
end
