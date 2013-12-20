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

ActiveRecord::Schema.define(version: 20131219104823) do

  create_table "channels", force: true do |t|
    t.string   "title",             null: false
    t.string   "slug",              null: false
    t.text     "description"
    t.string   "poster"
    t.datetime "last_update"
    t.string   "website",           null: false
    t.string   "author"
    t.string   "source_url",        null: false
    t.string   "hash_uid",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "poster_source_url"
  end

  add_index "channels", ["hash_uid"], name: "index_channels_on_hash_uid", unique: true, using: :btree
  add_index "channels", ["slug"], name: "index_channels_on_slug", unique: true, using: :btree
  add_index "channels", ["source_url"], name: "index_channels_on_source_url", unique: true, using: :btree

  create_table "episodes", force: true do |t|
    t.integer  "channel_id",   null: false
    t.string   "title",        null: false
    t.text     "description",  null: false
    t.datetime "published_at", null: false
    t.string   "link",         null: false
    t.string   "guid",         null: false
    t.integer  "media_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "episodes", ["channel_id"], name: "index_episodes_on_channel_id", using: :btree
  add_index "episodes", ["slug"], name: "index_episodes_on_slug", using: :btree

  create_table "media", force: true do |t|
    t.string   "file"
    t.string   "waveform"
    t.integer  "duration"
    t.string   "mime_type"
    t.string   "hash_sum"
    t.integer  "size"
    t.string   "source_url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
