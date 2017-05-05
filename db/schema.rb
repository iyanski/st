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

ActiveRecord::Schema.define(version: 20170505190555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "benefits", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["service_id"], name: "index_benefits_on_service_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "domain"
    t.string   "subdomain"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "country"
    t.string   "postal_code"
    t.string   "contact_no"
    t.string   "website"
    t.string   "blog"
    t.string   "logo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "job_id"
    t.string   "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_conversations_on_job_id", using: :btree
  end

  create_table "customer_settings", force: :cascade do |t|
    t.integer  "customer_id"
    t.boolean  "email_when_expert_claims",           default: true
    t.boolean  "email_when_expert_waives_claims",    default: true
    t.boolean  "email_when_expert_sends_estimate",   default: true
    t.boolean  "email_when_expert_cancels_estimate", default: true
    t.boolean  "email_when_expert_submits_work",     default: true
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.index ["customer_id"], name: "index_customer_settings_on_customer_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_customers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree
  end

  create_table "expert_settings", force: :cascade do |t|
    t.integer  "expert_id"
    t.boolean  "email_when_new_job_arrives",            default: true
    t.boolean  "email_when_user_approves_estimate",     default: true
    t.boolean  "email_when_user_approves_job",          default: true
    t.boolean  "email_when_user_cancels_claimed_job",   default: true
    t.boolean  "email_when_user_cancels_estimated_job", default: true
    t.boolean  "email_when_user_cancels_ongoing_job",   default: true
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["expert_id"], name: "index_expert_settings_on_expert_id", using: :btree
  end

  create_table "experts", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.datetime "suspended_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["company_id"], name: "index_experts_on_company_id", using: :btree
    t.index ["email"], name: "index_experts_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_experts_on_reset_password_token", unique: true, using: :btree
  end

  create_table "faqs", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "question"
    t.string   "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_faqs_on_service_id", using: :btree
  end

  create_table "job_attachments", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "expert_id"
    t.integer  "job_id"
    t.string   "file"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_job_attachments_on_customer_id", using: :btree
    t.index ["expert_id"], name: "index_job_attachments_on_expert_id", using: :btree
    t.index ["job_id"], name: "index_job_attachments_on_job_id", using: :btree
  end

  create_table "jobs", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "expert_id"
    t.integer  "category_id"
    t.string   "title"
    t.text     "description"
    t.integer  "status",       default: 0
    t.datetime "published_at"
    t.datetime "claimed_at"
    t.datetime "estimated_at"
    t.datetime "accepted_at"
    t.datetime "submitted_at"
    t.datetime "completed_at"
    t.datetime "closed_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "service_id"
    t.datetime "starts_at"
    t.float    "estimate"
    t.integer  "etc",          default: 0
    t.integer  "company_id"
    t.index ["category_id"], name: "index_jobs_on_category_id", using: :btree
    t.index ["company_id"], name: "index_jobs_on_company_id", using: :btree
    t.index ["customer_id"], name: "index_jobs_on_customer_id", using: :btree
    t.index ["expert_id"], name: "index_jobs_on_expert_id", using: :btree
    t.index ["service_id"], name: "index_jobs_on_service_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "job_id"
    t.string   "ip"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.float    "price"
    t.boolean  "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
    t.index ["job_id"], name: "index_orders_on_job_id", using: :btree
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "job_id"
    t.integer  "customer_id"
    t.integer  "expert_id"
    t.float    "cost"
    t.float    "commission"
    t.float    "fee"
    t.datetime "release_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["company_id"], name: "index_payment_transactions_on_company_id", using: :btree
    t.index ["customer_id"], name: "index_payment_transactions_on_customer_id", using: :btree
    t.index ["expert_id"], name: "index_payment_transactions_on_expert_id", using: :btree
    t.index ["job_id"], name: "index_payment_transactions_on_job_id", using: :btree
  end

  create_table "requirements", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["service_id"], name: "index_requirements_on_service_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.float    "price"
    t.integer  "service_type", default: 0
    t.string   "slug"
    t.string   "photo"
    t.float    "platform_fee", default: 13.0
    t.float    "experts_rate", default: 75.0
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "company_id"
    t.string   "avatar"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
