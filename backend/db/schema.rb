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

ActiveRecord::Schema[7.1].define(version: 2025_03_29_051314) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "math_topics", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "grade"
    t.string "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parameter_sets", force: :cascade do |t|
    t.bigint "question_template_id", null: false
    t.jsonb "parameters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_template_id"], name: "index_parameter_sets_on_question_template_id"
  end

  create_table "question_templates", force: :cascade do |t|
    t.bigint "math_topic_id", null: false
    t.string "title"
    t.text "question_formula"
    t.text "solution_steps"
    t.integer "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["math_topic_id"], name: "index_question_templates_on_math_topic_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "question_template_id", null: false
    t.bigint "parameter_set_id", null: false
    t.text "content"
    t.text "answer"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parameter_set_id"], name: "index_questions_on_parameter_set_id"
    t.index ["question_template_id"], name: "index_questions_on_question_template_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.text "user_answer"
    t.boolean "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_user_answers_on_question_id"
    t.index ["user_id"], name: "index_user_answers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "parameter_sets", "question_templates"
  add_foreign_key "question_templates", "math_topics"
  add_foreign_key "questions", "parameter_sets"
  add_foreign_key "questions", "question_templates"
  add_foreign_key "user_answers", "questions"
  add_foreign_key "user_answers", "users"
end
