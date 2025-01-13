class SorceryCore < ActiveRecord::Migration[7.2]
  def change
    # 既存のusersテーブルに必要なカラムを追加
    add_column :users, :email, :string, null: true
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string

    User.find(1).update(email: "misa@mail")
    User.find(2).update(email: "maeko@mail")

    change_column_null :users, :email, false
    add_index :users, :email, unique: true
  end
end
