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

ActiveRecord::Schema[7.1].define(version: 2024_04_30_201120) do
  create_table "animals", force: :cascade do |t|
    t.integer "status"
    t.json "feeding_times"
    t.json "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "habitat_id"
    t.string "name"
    t.string "species"
    t.index ["habitat_id"], name: "index_animals_on_habitat_id"
  end

  create_table "employees", force: :cascade do |t|
    t.integer "role"
    t.json "tasks"
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id"
    t.index ["auth_token"], name: "index_employees_on_auth_token", unique: true
    t.index ["manager_id"], name: "index_employees_on_manager_id"
  end

  create_table "habitats", force: :cascade do |t|
    t.string "name"
    t.json "environment_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.string "notable_type"
    t.integer "notable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employee_id"
    t.index ["employee_id"], name: "index_notes_on_employee_id"
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
  end

  create_table "piis", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.integer "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_piis_on_employee_id"
  end

  add_foreign_key "animals", "habitats"
  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "notes", "employees"
  add_foreign_key "piis", "employees"
end
