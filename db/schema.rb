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

ActiveRecord::Schema.define(:version => 20120514042437) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "book_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.text     "review"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "year",       :default => 0
    t.integer  "month",      :default => 0
    t.integer  "day",        :default => 0
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "image"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "approved",   :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "image"
    t.text     "info"
    t.string   "password_digest"
    t.datetime "password_reset_sent_at"
    t.string   "password_reset_token"
    t.string   "email_confirmation_token"
    t.boolean  "email_confirmed",          :default => false
    t.boolean  "admin",                    :default => false
    t.string   "username"
  end

end
