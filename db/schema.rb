# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160229230157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "days", force: :cascade do |t|
    t.datetime "day"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "days", ["user_id"], name: "index_days_on_user_id", using: :btree

  create_table "entries", force: :cascade do |t|
    t.datetime "time"
    t.integer  "user_id"
    t.integer  "day_id"
    t.string   "category"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "entries", ["day_id"], name: "index_entries_on_day_id", using: :btree
  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "entries_foods", id: false, force: :cascade do |t|
    t.integer "entry_id"
    t.integer "food_id"
  end

  add_index "entries_foods", ["entry_id"], name: "index_entries_foods_on_entry_id", using: :btree
  add_index "entries_foods", ["food_id"], name: "index_entries_foods_on_food_id", using: :btree

  create_table "entries_ingredients", id: false, force: :cascade do |t|
    t.integer "entry_id"
    t.integer "ingredient_id"
  end

  add_index "entries_ingredients", ["entry_id"], name: "index_entries_ingredients_on_entry_id", using: :btree
  add_index "entries_ingredients", ["ingredient_id"], name: "index_entries_ingredients_on_ingredient_id", using: :btree

  create_table "entries_meals", id: false, force: :cascade do |t|
    t.integer "entry_id"
    t.integer "meal_id"
  end

  add_index "entries_meals", ["entry_id"], name: "index_entries_meals_on_entry_id", using: :btree
  add_index "entries_meals", ["meal_id"], name: "index_entries_meals_on_meal_id", using: :btree

  create_table "foods", force: :cascade do |t|
    t.string   "brand"
    t.string   "name"
    t.string   "ingredients_list",                array: true
    t.string   "manufacturer"
    t.string   "category"
    t.string   "ean13"
    t.string   "upc"
    t.string   "factual_id"
    t.string   "image_urls"
    t.string   "sensitivity_groups",              array: true
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "foods_ingredients", id: false, force: :cascade do |t|
    t.integer "food_id"
    t.integer "ingredient_id"
  end

  add_index "foods_ingredients", ["food_id"], name: "index_foods_ingredients_on_food_id", using: :btree
  add_index "foods_ingredients", ["ingredient_id"], name: "index_foods_ingredients_on_ingredient_id", using: :btree

  create_table "foods_meals", id: false, force: :cascade do |t|
    t.integer "food_id"
    t.integer "meal_id"
  end

  add_index "foods_meals", ["food_id"], name: "index_foods_meals_on_food_id", using: :btree
  add_index "foods_meals", ["meal_id"], name: "index_foods_meals_on_meal_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.string   "sensitivity_groups",              array: true
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "ingredients_meals", id: false, force: :cascade do |t|
    t.integer "ingredient_id"
    t.integer "meal_id"
  end

  add_index "ingredients_meals", ["ingredient_id"], name: "index_ingredients_meals_on_ingredient_id", using: :btree
  add_index "ingredients_meals", ["meal_id"], name: "index_ingredients_meals_on_meal_id", using: :btree

  create_table "meals", force: :cascade do |t|
    t.string   "name"
    t.string   "foods_list",                    array: true
    t.string   "ingredients_list",              array: true
    t.string   "category"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "meals", ["user_id"], name: "index_meals_on_user_id", using: :btree

  create_table "symptoms", force: :cascade do |t|
    t.string   "name"
    t.integer  "severity"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "day_id"
    t.integer  "user_id"
  end

  add_index "symptoms", ["day_id"], name: "index_symptoms_on_day_id", using: :btree
  add_index "symptoms", ["user_id"], name: "index_symptoms_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "email"
    t.integer  "phone"
    t.string   "name"
    t.string   "image"
    t.string   "known_intolerances",                                   array: true
    t.string   "watching",                                             array: true
    t.string   "medical_disorders",                                    array: true
    t.boolean  "notifications_preference", default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

end
