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

ActiveRecord::Schema.define(version: 20170920154352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_types", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_course_types_on_name", unique: true
  end

  create_table "currency_types", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_currency_types_on_name", unique: true
  end

  create_table "menus", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.decimal "cost", precision: 10, scale: 2, null: false
    t.bigint "course_type_id", null: false
    t.bigint "currency_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "menu_date", null: false
    t.string "picture", default: "", null: false
    t.index ["course_type_id"], name: "index_menus_on_course_type_id"
    t.index ["currency_type_id"], name: "index_menus_on_currency_type_id"
    t.index ["name", "course_type_id", "menu_date"], name: "name_uq", unique: true
    t.index ["picture"], name: "index_menus_on_picture"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "menu_id", null: false
    t.bigint "course_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "order_date", null: false
    t.index ["course_type_id"], name: "index_orders_on_course_type_id"
    t.index ["menu_id"], name: "index_orders_on_menu_id"
    t.index ["user_id", "course_type_id", "menu_id", "order_date"], name: "course_type_uq", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 20, null: false
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
