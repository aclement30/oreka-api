# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171210051724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_providers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_auth_providers_on_provider_and_uid", unique: true
    t.index ["user_id", "uid"], name: "index_auth_providers_on_user_id_and_uid", unique: true
    t.index ["user_id"], name: "index_auth_providers_on_user_id"
  end

  create_table "balances", force: :cascade do |t|
    t.decimal "amount", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "couple_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["couple_id", "name"], name: "index_categories_on_couple_id_and_name", unique: true
    t.index ["couple_id"], name: "index_categories_on_couple_id"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "couples", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "date", null: false
    t.string "type", null: false
    t.string "description"
    t.decimal "amount", null: false
    t.string "currency", default: "CAD", null: false
    t.decimal "payer_share"
    t.string "notes"
    t.integer "payer_id", null: false
    t.datetime "deleted_at"
    t.bigint "category_id"
    t.bigint "couple_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["couple_id"], name: "index_transactions_on_couple_id"
    t.index ["date"], name: "index_transactions_on_date"
    t.index ["deleted_at"], name: "index_transactions_on_deleted_at"
    t.index ["payer_id"], name: "index_transactions_on_payer_id"
    t.index ["type"], name: "index_transactions_on_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.datetime "deleted_at"
    t.bigint "couple_id"
    t.bigint "balance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_url"
    t.index ["balance_id"], name: "index_users_on_balance_id"
    t.index ["couple_id"], name: "index_users_on_couple_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "auth_providers", "users"
  add_foreign_key "transactions", "users", column: "payer_id"
end
