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

ActiveRecord::Schema.define(:version => 20120610112023) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "access_token"
  end

  create_table "book_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.text     "review"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "year",       :default => 0
    t.integer  "month",      :default => 0
    t.integer  "day",        :default => 0
    t.string   "privacy",    :default => "Friends"
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "image"
    t.string   "authors"
    t.string   "translators"
    t.string   "publisher"
    t.string   "pub_date"
    t.string   "category"
    t.string   "isbn"
    t.string   "isbn13"
    t.string   "api_id"
  end

  create_table "comments", :force => true do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "book_post_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "comments", ["book_post_id"], :name => "index_comments_on_book_post_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "approved",   :default => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "book_post_id"
    t.integer  "comment_id"
    t.string   "notification_type"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "image"
    t.text     "info"
    t.string   "password_digest"
    t.datetime "password_reset_sent_at"
    t.string   "password_reset_token"
    t.string   "email_confirmation_token"
    t.boolean  "email_confirmed",          :default => false
    t.boolean  "admin",                    :default => false
    t.string   "bookshelf_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "bookshelf_privacy",        :default => "Users"
    t.string   "book_api",                 :default => "daum"
    t.datetime "latest_login_at"
  end

end
