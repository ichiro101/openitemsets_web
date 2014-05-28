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

ActiveRecord::Schema.define(version: 20140528053021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exception_records", force: true do |t|
    t.text     "class_name"
    t.text     "message"
    t.text     "backtrace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_set_comments", force: true do |t|
    t.integer  "item_set_id", null: false
    t.integer  "user_id",     null: false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_sets", force: true do |t|
    t.string   "title",             default: ""
    t.string   "ingame_title",      default: "Untitled Itemset", null: false
    t.string   "champion",          default: "Ahri",             null: false
    t.string   "role",                                           null: false
    t.text     "description"
    t.integer  "user_id",           default: 0,                  null: false
    t.boolean  "visible_to_public", default: false,              null: false
    t.integer  "map_option"
    t.integer  "map"
    t.text     "item_set_json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "item_set_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_providers", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                                 null: false
    t.string   "email"
    t.string   "email_confirmation_token"
    t.boolean  "email_confirmed",          default: false, null: false
    t.string   "hashed_password",                          null: false
    t.string   "password_reset_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin",                    default: 0,     null: false
  end

end
