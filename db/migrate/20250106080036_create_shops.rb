class CreateShops < ActiveRecord::Migration[7.2]
  def change
    create_table :shops do |t|
      t.string :name, null:false
      t.string :address, null:true
      t.string :tel, null:true
      t.timestamps
    end
  end
end
