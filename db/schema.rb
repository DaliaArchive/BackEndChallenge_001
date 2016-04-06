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

ActiveRecord::Schema.define(version: 20160405071344) do

  create_table "features", force: :cascade do |t|
    t.integer  "maintenance_record_id", limit: 4
    t.string   "key",                   limit: 100
    t.string   "value",                 limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "maintenance_records", force: :cascade do |t|
    t.integer  "robot_id",   limit: 4
    t.string   "action",     limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "robots", force: :cascade do |t|
    t.integer  "current_maintenance_record_id", limit: 4
    t.string   "name",                          limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

end
