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

ActiveRecord::Schema.define(version: 2018_11_28_004010) do

  create_table "domain_name_systems", force: :cascade do |t|
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_domain_name_systems_on_address", unique: true
  end

  create_table "hosts", force: :cascade do |t|
    t.integer "dns_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dns_id", "name"], name: "index_hosts_on_dns_id_and_name", unique: true
    t.index ["dns_id"], name: "index_hosts_on_dns_id"
    t.index ["id"], name: "index_hosts_on_id"
  end

end
