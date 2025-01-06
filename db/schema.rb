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

ActiveRecord::Schema[7.2].define(version: 2025_01_06_083736) do
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
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_budgets_on_category_id"
    t.index ["money_file_id"], name: "index_budgets_on_money_file_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "money_files", force: :cascade do |t|
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.index ["user_id"], name: "index_money_files_on_user_id"
  end

  create_table "payment_data", force: :cascade do |t|
    t.integer "amount", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "budget_id", null: false
    t.integer "payment_method_id", null: false
    t.integer "shop_id"
    t.string "title"
    t.datetime "date", null: false
    t.index ["budget_id"], name: "index_payment_data_on_budget_id"
    t.index ["payment_method_id"], name: "index_payment_data_on_payment_method_id"
    t.index ["shop_id"], name: "index_payment_data_on_shop_id"
  end

  create_table "payment_data_categories", force: :cascade do |t|
    t.integer "payment_datum_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_payment_data_categories_on_category_id"
    t.index ["payment_datum_id"], name: "index_payment_data_categories_on_payment_datum_id"
  end

  create_table "payment_data_payment_methods", force: :cascade do |t|
    t.integer "payment_datum_id", null: false
    t.integer "payment_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_datum_id"], name: "index_payment_data_payment_methods_on_payment_datum_id"
    t.index ["payment_method_id"], name: "index_payment_data_payment_methods_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "tel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "budget_categories", "budgets"
  add_foreign_key "budget_categories", "categories"
  add_foreign_key "budgets", "categories"
  add_foreign_key "budgets", "money_files"
  add_foreign_key "money_files", "users"
  add_foreign_key "payment_data", "budgets"
  add_foreign_key "payment_data", "payment_methods"
  add_foreign_key "payment_data", "shops"
  add_foreign_key "payment_data_categories", "categories"
  add_foreign_key "payment_data_categories", "payment_data"
  add_foreign_key "payment_data_payment_methods", "payment_data"
  add_foreign_key "payment_data_payment_methods", "payment_methods"
end
