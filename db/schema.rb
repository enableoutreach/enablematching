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

ActiveRecord::Schema.define(version: 20170318083140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "chapters", force: :cascade do |t|
    t.integer  "lead"
    t.boolean  "active"
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.text     "location"
    t.text     "home"
    t.text     "donation"
    t.text     "intake"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "devices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "title"
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "first_name",                             null: false
    t.text     "last_name"
    t.text     "city"
    t.text     "country"
    t.boolean  "active",                 default: true,  null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.text     "email",                                  null: false
    t.boolean  "admin",                  default: false
    t.float    "latitude",               default: 0.0
    t.float    "longitude",              default: 0.0
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "from"
    t.integer  "to"
    t.text     "content"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "status",     default: "Unread"
  end

  create_table "offers", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "request_id",                     null: false
    t.integer  "member_id",                      null: false, comment: "id of member offering to help"
    t.text     "stage",      default: "Offered", null: false
    t.index ["request_id", "member_id"], name: "dupeOffer", unique: true, using: :btree
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "member_id",                         null: false, comment: "id of member asking for help"
    t.integer  "device_id"
    t.text     "side"
    t.text     "stage",            default: "Open", null: false
    t.float    "latitude",         default: 0.0
    t.float    "longitude",        default: 0.0
    t.text     "shipping_address"
    t.boolean  "completed"
    t.text     "completionnote"
  end

end
