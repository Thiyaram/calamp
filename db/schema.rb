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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121117083427) do

  create_table "auditlogs", :force => true do |t|
    t.integer  "user_id",          :default => 0
    t.string   "task_type",                       :null => false
    t.string   "task_description",                :null => false
    t.text     "task_detail",                     :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "auditlogs", ["created_at"], :name => "index_auditlogs_on_created_at"
  add_index "auditlogs", ["user_id"], :name => "index_auditlogs_on_user_id"

  create_table "devices", :force => true do |t|
    t.string   "imei",            :limit => 30,                    :null => false
    t.datetime "registered_date",                                  :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.boolean  "status",                        :default => false
  end

  add_index "devices", ["imei", "deleted_at"], :name => "index_devices_on_imei_and_deleted_at", :unique => true

  create_table "messages", :force => true do |t|
    t.text     "received_data", :null => false
    t.text     "hex_data"
    t.string   "client_addr"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "device_id"
  end

  add_index "messages", ["device_id"], :name => "index_messages_on_device_id"
  add_index "messages", ["received_data"], :name => "index_messages_on_received_data"

  create_table "options_headers", :force => true do |t|
    t.integer  "device_id",                :null => false
    t.integer  "message_id",               :null => false
    t.string   "options_byte",             :null => false
    t.integer  "mobile_id_length"
    t.string   "mobile_id"
    t.integer  "mobile_id_type_length"
    t.string   "mobile_id_type"
    t.integer  "authentication_length"
    t.string   "authentication_data"
    t.integer  "routing_length"
    t.string   "routing_data"
    t.integer  "forwarding_length"
    t.string   "forwarding_address"
    t.string   "forwarding_port"
    t.string   "forwarding_protocol"
    t.string   "forwarding_operation"
    t.integer  "resp_redirection_length"
    t.string   "resp_redirection_address"
    t.string   "resp_redirection_port"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "options_headers", ["device_id"], :name => "index_options_headers_on_device_id"
  add_index "options_headers", ["message_id"], :name => "index_options_headers_on_message_id"

  create_table "roles", :force => true do |t|
    t.string   "name",        :limit => 15,  :null => false
    t.string   "description", :limit => 250
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name",                   :limit => 50,                     :null => false
    t.string   "email",                  :limit => 150,                    :null => false
    t.string   "password_digest",                                          :null => false
    t.integer  "role_id",                                                  :null => false
    t.boolean  "active",                                :default => false, :null => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.datetime "deleted_at"
    t.string   "activation_key"
    t.integer  "invalid_attempts",       :limit => 2
    t.datetime "last_login"
  end

  add_index "users", ["email", "deleted_at"], :name => "index_users_on_email_and_deleted_at", :unique => true
  add_index "users", ["password_reset_token"], :name => "index_users_on_password_reset_token"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"

end
