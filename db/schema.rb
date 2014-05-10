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

ActiveRecord::Schema.define(version: 20140510211215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: true do |t|
    t.integer  "user_id",                null: false
    t.integer  "points",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bets", ["user_id"], name: "index_bets_on_user_id", unique: true, using: :btree

  create_table "matches", force: true do |t|
    t.integer  "number",                    null: false
    t.string   "round",                     null: false
    t.string   "group",           limit: 1
    t.datetime "played_at",                 null: false
    t.string   "played_on",                 null: false
    t.integer  "team_a_id"
    t.integer  "team_b_id"
    t.integer  "goals_a"
    t.integer  "goals_b"
    t.integer  "penalty_goals_a"
    t.integer  "penalty_goals_b"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["group"], name: "index_matches_on_group", using: :btree
  add_index "matches", ["number"], name: "index_matches_on_number", unique: true, using: :btree
  add_index "matches", ["round"], name: "index_matches_on_round", using: :btree
  add_index "matches", ["team_a_id"], name: "index_matches_on_team_a_id", using: :btree
  add_index "matches", ["team_b_id"], name: "index_matches_on_team_b_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name_en",              null: false
    t.string   "name_pt",              null: false
    t.string   "acronym",    limit: 3, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group",      limit: 1, null: false
  end

  add_index "teams", ["acronym"], name: "index_teams_on_acronym", unique: true, using: :btree
  add_index "teams", ["group"], name: "index_teams_on_group", using: :btree
  add_index "teams", ["name_en"], name: "index_teams_on_name_en", unique: true, using: :btree
  add_index "teams", ["name_pt"], name: "index_teams_on_name_pt", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                           null: false
    t.string   "time_zone",                       null: false
    t.string   "locale",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token",               null: false
    t.string   "authentication_token"
    t.datetime "authentication_token_expires_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", unique: true, using: :btree

end
