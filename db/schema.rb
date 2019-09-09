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

ActiveRecord::Schema.define(version: 20190828151854) do

  create_table "users", force: :cascade do |t|
    t.string   "nome"
    t.string   "cognome"
    t.string   "codice_fiscale"
    t.string   "sesso"
    t.date     "data_nascita"
    t.string   "nazione_nascita"
    t.string   "luogo_nascita"
    t.string   "nazione_residenza"
    t.string   "citta_residenza"
    t.string   "indirizzo"
    t.string   "email"
    t.string   "numero_telefono"
    t.string   "refresh_token"
    t.string   "token"
    t.boolean  "is_doctor",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "password_digest"
    t.string   "regione"
    t.string   "regione_residenza"
    t.boolean  "admin",                  default: false
    t.string   "activation_digest"
    t.boolean  "activated",              default: false
    t.datetime "activated_at"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "current_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "expires"
    t.integer  "expires_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "visits", force: :cascade do |t|
    t.string   "tipo"
    t.time     "ora_inizio"
    t.time     "ora_fine"
    t.date     "data_inizio"
    t.date     "data_fine"
    t.integer  "paziente"
    t.text     "descrizione"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
