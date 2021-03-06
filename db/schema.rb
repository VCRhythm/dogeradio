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

ActiveRecord::Schema.define(version: 20140408144458) do

  create_table "beta_codes", force: true do |t|
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "creators_events", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  add_index "creators_events", ["user_id", "event_id"], name: "index_creators_events_on_user_id_and_event_id"

  create_table "delayed_jobs", force: true do |t|
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

  create_table "events", force: true do |t|
    t.boolean  "featured"
    t.string   "name"
    t.integer  "venue_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "moment"
  end

  create_table "favorites", force: true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["track_id", "user_id"], name: "index_favorites_on_track_id_and_user_id", unique: true
  add_index "favorites", ["track_id"], name: "index_favorites_on_track_id"
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "musics", force: true do |t|
    t.string   "name"
    t.integer  "user_id",                             null: false
    t.string   "direct_upload_url",                   null: false
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.boolean  "processed",           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "musics", ["processed"], name: "index_musics_on_processed"
  add_index "musics", ["user_id"], name: "index_musics_on_user_id"

  create_table "payouts", force: true do |t|
    t.integer  "user_id"
    t.float    "value"
    t.boolean  "done",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payouts", ["user_id"], name: "index_payouts_on_user_id"

  create_table "playlists", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",   default: "playlist"
  end

  create_table "playlists_tracks", id: false, force: true do |t|
    t.integer "playlist_id"
    t.integer "track_id"
  end

  add_index "playlists_tracks", ["playlist_id"], name: "index_playlists_tracks_on_playlist_id"
  add_index "playlists_tracks", ["track_id", "playlist_id"], name: "index_playlists_tracks_on_track_id_and_playlist_id"

  create_table "plays", force: true do |t|
    t.integer  "count",      default: 1
    t.integer  "track_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plays", ["track_id"], name: "index_plays_on_track_id"
  add_index "plays", ["user_id"], name: "index_plays_on_user_id"

  create_table "ranks", force: true do |t|
    t.integer  "track_id"
    t.integer  "playlist_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "ranks", ["playlist_id"], name: "index_ranks_on_playlist_id"
  add_index "ranks", ["track_id"], name: "index_ranks_on_track_id"

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "simple_captcha_data", force: true do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key"

  create_table "tags", force: true do |t|
    t.integer  "object_id"
    t.string   "category"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "what"
  end

  add_index "tags", ["object_id"], name: "index_tags_on_object_id"

  create_table "tracks", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "user_id"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracks", ["user_id"], name: "index_tracks_on_user_id"

  create_table "transactions", force: true do |t|
    t.integer  "payee_id"
    t.integer  "payer_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "method"
    t.integer  "track_id"
    t.boolean  "pending",    default: true
    t.string   "email"
    t.string   "account"
  end

  add_index "transactions", ["track_id"], name: "index_transactions_on_track_id"

  create_table "users", force: true do |t|
    t.string   "email",                   default: "",    null: false
    t.string   "encrypted_password",      default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "account"
    t.float    "balance",                 default: 0.0
    t.integer  "code"
    t.float    "prev_received",           default: 0.0
    t.text     "bio"
    t.string   "payout_account"
    t.string   "soundcloud_access_token"
    t.float    "default_tip_amount",      default: 5.0
    t.float    "wow_tip_amount",          default: 5.0
    t.float    "donation_percent",        default: 0.0
    t.float    "transaction_fee",         default: 0.04
    t.string   "website"
    t.boolean  "autotip",                 default: false
    t.string   "display_name"
    t.string   "address"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "publish_address",         default: false
    t.float    "distance"
    t.string   "time_zone",               default: "UTC"
    t.boolean  "admin",                   default: false
    t.boolean  "guest",                   default: false
    t.boolean  "verified",                default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["lat", "lng"], name: "index_users_on_lat_and_lng"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "users_events", force: true do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  create_table "venues", force: true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "gmaps"
    t.float    "distance"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "jambase_id"
  end

  add_index "venues", ["user_id"], name: "index_venues_on_user_id"

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["tag_id"], name: "index_votes_on_tag_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
