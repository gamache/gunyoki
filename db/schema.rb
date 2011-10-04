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

ActiveRecord::Schema.define(:version => 20111003194407) do

  create_table "clans", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clans_players", :force => true do |t|
    t.integer  "clan_id",    :null => false
    t.integer  "player_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clans_players", ["clan_id"], :name => "index_clans_players_on_clan_id"
  add_index "clans_players", ["player_id"], :name => "index_clans_players_on_player_id"

  create_table "games", :force => true do |t|
    t.integer  "player_id"
    t.integer  "tournament_id"
    t.string   "reported_game_id"
    t.string   "player_name"
    t.string   "role"
    t.string   "race"
    t.string   "start_gender"
    t.string   "start_alignment"
    t.string   "end_gender"
    t.string   "end_alignment"
    t.integer  "end_level"
    t.integer  "end_hp"
    t.integer  "max_level"
    t.integer  "max_hp"
    t.string   "end_msg"
    t.string   "end_loc"
    t.integer  "deaths"
    t.integer  "extinctions"
    t.integer  "end_dungeon"
    t.integer  "turns"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "seconds_played"
    t.integer  "score"
    t.boolean  "got_bell"
    t.boolean  "entered_gehennom"
    t.boolean  "got_candelabrum"
    t.boolean  "got_book"
    t.boolean  "did_invocation"
    t.boolean  "got_amulet"
    t.boolean  "reached_elemental"
    t.boolean  "reached_astral"
    t.boolean  "ascended"
    t.boolean  "did_mines"
    t.boolean  "did_sokoban"
    t.boolean  "killed_medusa"
    t.integer  "achievements"
    t.boolean  "foodless"
    t.boolean  "vegan"
    t.boolean  "vegetarian"
    t.boolean  "atheist"
    t.boolean  "weaponless"
    t.boolean  "pacifist"
    t.boolean  "illiterate"
    t.boolean  "polypileless"
    t.boolean  "polyselfless"
    t.boolean  "wishless"
    t.boolean  "artifact_wishless"
    t.boolean  "genocideless"
    t.integer  "conducts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["ascended"], :name => "index_games_on_ascended"
  add_index "games", ["player_id"], :name => "index_games_on_player_id"
  add_index "games", ["tournament_id"], :name => "index_games_on_tournament_id"

  create_table "players", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
