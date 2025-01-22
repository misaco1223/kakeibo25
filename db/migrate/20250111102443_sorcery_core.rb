class SorceryCore < ActiveRecord::Migration[7.2]
  def change
    # 既存のusersテーブルに必要なカラムを追加
    add_column :users, :email, :string, null: false
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
    add_index :users, :email, unique: true
  end
end
