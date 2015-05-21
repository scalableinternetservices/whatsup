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

ActiveRecord::Schema.define(version: 20150521192213) do

  create_table "attendances", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "event_id",   limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "comments", ["event_id"], name: "index_comments_on_event_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "event_categories", force: :cascade do |t|
    t.integer  "event_id",   limit: 4
    t.string   "category",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "location",    limit: 255
    t.decimal  "latitude",                  precision: 10, scale: 3
    t.decimal  "longitude",                 precision: 10, scale: 3
    t.datetime "start_time"
    t.text     "description", limit: 65535
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "user_id",     limit: 4
    t.datetime "end_time"
    t.string   "category",    limit: 255
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "message",      limit: 255
    t.integer  "event_id",     limit: 4
    t.boolean  "hasSeen",      limit: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "from_user_id", limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "comments", "events"
  add_foreign_key "comments", "users"
end
