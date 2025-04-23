# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_22_084148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discount_codes", force: :cascade do |t|
    t.string "code", null: false
    t.string "discount_type"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "expires_at"
    t.integer "max_uses"
    t.integer "times_used", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_discount_codes_on_code", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "venue"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "status"
    t.integer "category"
    t.string "subcategory"
    t.decimal "price"
    t.integer "early_bird_discount"
    t.datetime "early_bird_deadline"
    t.integer "max_participants"
    t.boolean "id_proof_required"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "id_proof_type"
    t.string "uploaded_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_participants_on_registration_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.string "receipt_number"
    t.datetime "payment_date"
    t.decimal "amount"
    t.integer "payment_method"
    t.string "transaction_id"
    t.datetime "generated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_receipts_on_registration_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.integer "number_of_participants"
    t.bigint "discount_code_id", null: false
    t.decimal "amount_paid", precision: 10, scale: 2
    t.string "payment_method"
    t.string "payment_status", null: false
    t.datetime "registered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_code_id"], name: "index_registrations_on_discount_code_id"
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "events", "users"
  add_foreign_key "participants", "registrations"
  add_foreign_key "receipts", "registrations"
  add_foreign_key "registrations", "discount_codes"
  add_foreign_key "registrations", "events"
  add_foreign_key "registrations", "users"
end
