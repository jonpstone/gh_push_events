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

ActiveRecord::Schema[8.1].define(version: 2026_02_18_194240) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "github_events", force: :cascade do |t|
    t.string "actor_avatar_url"
    t.bigint "actor_id"
    t.string "actor_login"
    t.string "actor_type"
    t.datetime "created_at", null: false
    t.string "event_id", null: false
    t.string "event_type", null: false
    t.datetime "github_created_at"
    t.jsonb "payload", default: {}, null: false
    t.jsonb "raw_payload", null: false
    t.bigint "repo_id"
    t.string "repo_name"
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_github_events_on_actor"
    t.index ["event_id", "event_type"], name: "index_github_events_on_event_id_and_event_type"
    t.index ["event_id"], name: "index_github_events_on_event_id"
    t.index ["event_type"], name: "index_github_events_on_event_type"
    t.index ["github_created_at"], name: "index_github_events_on_github_created_at"
  end

  create_table "push_events", force: :cascade do |t|
    t.string "before", null: false
    t.datetime "created_at", null: false
    t.bigint "github_event_id", null: false
    t.string "head", null: false
    t.string "push_id", null: false
    t.string "ref", null: false
    t.bigint "repository_id", null: false
    t.datetime "updated_at", null: false
    t.index ["before"], name: "index_push_events_on_before"
    t.index ["github_event_id"], name: "index_push_events_on_github_event_id"
    t.index ["head"], name: "index_push_events_on_head"
    t.index ["push_id"], name: "index_push_events_on_push_id"
    t.index ["ref"], name: "index_push_events_on_ref"
    t.index ["repository_id"], name: "index_push_events_on_repository_id"
  end

  add_foreign_key "push_events", "github_events"
end
