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

ActiveRecord::Schema.define(:version => 20110825140213) do

  create_table "quotes", :force => true do |t|
    t.string   "symbol"
    t.string   "name"
    t.decimal  "price",                :precision => 10, :scale => 2
    t.datetime "date"
    t.decimal  "low",                  :precision => 10, :scale => 2
    t.decimal  "high",                 :precision => 10, :scale => 2
    t.decimal  "open",                 :precision => 10, :scale => 2
    t.decimal  "close",                :precision => 10, :scale => 2
    t.decimal  "ask",                  :precision => 10, :scale => 2
    t.decimal  "bid",                  :precision => 10, :scale => 2
    t.decimal  "bid_size",             :precision => 10, :scale => 2
    t.integer  "volume"
    t.integer  "average_daily_volume"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quotes", ["symbol", "date"], :name => "index_quotes_on_symbol_and_date", :unique => true

end
