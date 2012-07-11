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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120501162804) do

  create_table "entries", :force => true do |t|
    t.integer  "hacker_id",  :null => false
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "entries", ["hacker_id"], :name => "index_entries_on_hacker_id"

  create_table "entries_tags", :id => false, :force => true do |t|
    t.integer "entry_id", :null => false
    t.integer "tag_id",   :null => false
  end

  add_index "entries_tags", ["entry_id", "tag_id"], :name => "index_entries_tags_on_entry_id_and_tag_id", :unique => true

  create_table "hackers", :force => true do |t|
    t.string   "email",                                                            :null => false
    t.string   "name"
    t.string   "password_digest",                                                  :null => false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "time_zone",              :default => "Pacific Time (US & Canada)"
    t.boolean  "enabled",                :default => true
    t.boolean  "save_tags",              :default => true
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "hackers", ["email"], :name => "index_hackers_on_email", :unique => true

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

end
