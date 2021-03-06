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

ActiveRecord::Schema.define(version: 20160212082603) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applied_jobs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "vacancy_id"
    t.boolean  "viewed",     default: false
    t.boolean  "rejected",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "applied_jobs", ["user_id", "vacancy_id"], name: "index_applied_jobs_on_user_id_and_vacancy_id", unique: true, using: :btree
  add_index "applied_jobs", ["vacancy_id", "user_id"], name: "index_applied_jobs_on_vacancy_id_and_user_id", unique: true, using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "url"
    t.string   "status",      default: "inactive"
  end

  create_table "invite_codes", force: :cascade do |t|
    t.boolean  "used",       default: false
    t.string   "code"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "specialities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "first_name",                             null: false
    t.string   "last_name",                              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "speciality_id"
    t.string   "country"
    t.string   "city"
    t.string   "resume"
    t.string   "role"
    t.boolean  "approved",               default: false, null: false
    t.string   "invite_code"
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["speciality_id"], name: "index_users_on_speciality_id", using: :btree

  create_table "vacancies", force: :cascade do |t|
    t.string   "title"
    t.date     "deadline"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "speciality_id"
    t.string   "city"
    t.string   "country"
  end

  add_index "vacancies", ["company_id"], name: "index_vacancies_on_company_id", using: :btree
  add_index "vacancies", ["speciality_id"], name: "index_vacancies_on_speciality_id", using: :btree

  add_foreign_key "users", "specialities"
  add_foreign_key "vacancies", "specialities"
end
