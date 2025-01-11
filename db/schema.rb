# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_01_10_113141) do
  create_table "budget_categories", force: :cascade do |t|
    t.integer "budget_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_budget_categories_on_budget_id"
    t.index ["category_id"], name: "index_budget_categories_on_category_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.integer "money_file_id", null: false
    t.integer "amount", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["money_file_id"], name: "index_budgets_on_money_file_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "money_files", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_money_files_on_user_id"
  end

  create_table "pay_methods", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pay_methods_on_user_id"
  end

  create_table "payment_pay_methods", force: :cascade do |t|
    t.integer "payment_id", null: false
    t.integer "pay_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pay_method_id"], name: "index_payment_pay_methods_on_pay_method_id"
    t.index ["payment_id"], name: "index_payment_pay_methods_on_payment_id"
  end

  create_table "payment_shops", force: :cascade do |t|
    t.integer "payment_id", null: false
    t.integer "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_payment_shops_on_payment_id"
    t.index ["shop_id"], name: "index_payment_shops_on_shop_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "budget_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "amount", null: false
    t.datetime "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_payments_on_budget_id"
  end

  create_table "shops", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "address"
    t.string "tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shops_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "budget_categories", "budgets"
  add_foreign_key "budget_categories", "categories"
  add_foreign_key "budgets", "money_files"
  add_foreign_key "categories", "users"
  add_foreign_key "money_files", "users"
  add_foreign_key "pay_methods", "users"
  add_foreign_key "payment_pay_methods", "pay_methods"
  add_foreign_key "payment_pay_methods", "payments"
  add_foreign_key "payment_shops", "payments"
  add_foreign_key "payment_shops", "shops"
  add_foreign_key "payments", "budgets"
  add_foreign_key "shops", "users"
end
