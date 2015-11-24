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

ActiveRecord::Schema.define(version: 20151124194326) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "fb_page_posts", force: :cascade do |t|
    t.integer  "fb_page_id"
    t.string   "fb_post_id"
    t.text     "message"
    t.integer  "share_count"
    t.integer  "comment_count"
    t.integer  "like_count"
    t.integer  "impression_count"
    t.datetime "date_posted"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "fb_page_posts", ["fb_page_id", "fb_post_id"], name: "index_fb_page_posts_on_fb_page_id_and_fb_post_id", unique: true

  create_table "fb_page_users", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "fb_page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fb_page_users", ["fb_page_id", "users_id"], name: "index_fb_page_users_on_fb_page_id_and_users_id", unique: true
  add_index "fb_page_users", ["fb_page_id"], name: "index_fb_page_users_on_fb_page_id"
  add_index "fb_page_users", ["users_id"], name: "index_fb_page_users_on_users_id"

  create_table "fb_pages", force: :cascade do |t|
    t.string   "name"
    t.integer  "fb_page_id", limit: 8
    t.string   "category"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "fb_pages", ["fb_page_id"], name: "index_fb_pages_on_fb_page_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "oauth_token"
    t.string   "oauth_expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  add_index "users", ["uid"], name: "index_users_on_uid"

end
