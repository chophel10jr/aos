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

ActiveRecord::Schema[8.0].define(version: 2025_07_09_054319) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "account_documents", force: :cascade do |t|
    t.string "document_type"
    t.text "base64_data"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_documents_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "account_number"
    t.string "base_number"
    t.string "currency"
    t.string "account_type"
    t.string "mode_of_operation"
    t.string "branch_code"
    t.string "status"
    t.text "remarks"
    t.boolean "sync_with_obo", default: false
    t.string "obo_application_no"
    t.string "thread_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_type"
    t.string "country"
    t.string "district"
    t.string "sub_district"
    t.string "block"
    t.string "village"
    t.string "land_record_number"
    t.string "house_number"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_addresses_on_account_id"
  end

  create_table "contact_details", force: :cascade do |t|
    t.string "contact_number"
    t.string "email_id"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_contact_details_on_account_id"
  end

  create_table "emergency_contacts", force: :cascade do |t|
    t.string "name"
    t.string "relationship"
    t.string "contact_number"
    t.string "cid_number"
    t.text "address"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_emergency_contacts_on_account_id"
  end

  create_table "employment_details", force: :cascade do |t|
    t.string "employment_type"
    t.string "employee_type"
    t.string "employee_id"
    t.string "organization_name"
    t.string "organization_address"
    t.string "designation"
    t.bigint "personal_detail_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personal_detail_id"], name: "index_employment_details_on_personal_detail_id"
  end

  create_table "identity_details", force: :cascade do |t|
    t.string "id_type"
    t.string "id_number"
    t.date "id_issued_on"
    t.date "id_expires_on"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_identity_details_on_account_id"
  end

  create_table "income_details", force: :cascade do |t|
    t.string "source_of_income"
    t.decimal "gross_annual_income"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_income_details_on_account_id"
  end

  create_table "nominees", force: :cascade do |t|
    t.string "name"
    t.date "date_of_birth"
    t.string "relationship"
    t.string "cid_number"
    t.string "contact_number"
    t.decimal "share_percentage"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_nominees_on_account_id"
  end

  create_table "personal_details", force: :cascade do |t|
    t.string "salutation"
    t.string "gender"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "nationality"
    t.string "education_level"
    t.string "marital_status"
    t.string "employment_status"
    t.string "tax_payer_no"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_personal_details_on_account_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spouse_details", force: :cascade do |t|
    t.string "name"
    t.date "date_of_birth"
    t.string "cid_number"
    t.string "contact_number"
    t.string "education_level"
    t.string "employment_status"
    t.string "account_number"
    t.integer "number_of_children"
    t.bigint "personal_detail_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personal_detail_id"], name: "index_spouse_details_on_personal_detail_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.string "email"
    t.string "password"
    t.string "branch"
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "account_documents", "accounts"
  add_foreign_key "addresses", "accounts"
  add_foreign_key "contact_details", "accounts"
  add_foreign_key "emergency_contacts", "accounts"
  add_foreign_key "employment_details", "personal_details"
  add_foreign_key "identity_details", "accounts"
  add_foreign_key "income_details", "accounts"
  add_foreign_key "nominees", "accounts"
  add_foreign_key "personal_details", "accounts"
  add_foreign_key "spouse_details", "personal_details"
  add_foreign_key "users", "roles"
end
