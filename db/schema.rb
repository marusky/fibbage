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

ActiveRecord::Schema[8.0].define(version: 2026_07_14_195045) do
  create_table "answers", force: :cascade do |t|
    t.integer "player_id"
    t.integer "question_id", null: false
    t.string "text", null: false
    t.boolean "our_lie", default: false, null: false
    t.boolean "truth", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_answers_on_player_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "games", force: :cascade do |t|
    t.boolean "on", default: false, null: false
    t.string "code", null: false
    t.integer "question_number", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lies", force: :cascade do |t|
    t.string "text"
    t.boolean "audience"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_lies_on_question_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points", default: 0, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "state", default: "initial", null: false
    t.text "question", null: false
    t.datetime "answerable_until"
    t.integer "order"
    t.integer "points", default: 0, null: false
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_questions_on_game_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "answer_id", null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_votes_on_answer_id"
    t.index ["player_id"], name: "index_votes_on_player_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "votes", "answers"
  add_foreign_key "votes", "players"
end
