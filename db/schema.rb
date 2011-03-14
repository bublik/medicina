# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090915073434) do

  create_table "attachments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["post_id", "parent_id"], :name => "attachmet_post_ind"

  create_table "bcomments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bcomments", ["user_id", "post_id"], :name => "bcommen_user_post_ind"

  create_table "categories", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "first_page", :default => false
  end

  create_table "post_translations", :force => true do |t|
    t.integer  "post_id"
    t.string   "locale"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_translations", ["post_id"], :name => "index_post_translations_on_post_id"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["user_id", "category_id"], :name => "posts_user_categ_ind"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_config_translations", :force => true do |t|
    t.integer  "site_config_id"
    t.string   "locale"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_config_translations", ["site_config_id"], :name => "index_site_config_translations_on_site_config_id"

  create_table "site_configs", :force => true do |t|
    t.text     "body"
    t.string   "identifier"
    t.boolean  "is_active",  :default => true
    t.date     "disable_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "typus_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "preferences"
  end

  create_table "users", :force => true do |t|
    t.string   "login",          :limit => 15,  :default => "",    :null => false
    t.string   "email",          :limit => 50,  :default => "",    :null => false
    t.string   "first_name",     :limit => 20,  :default => "",    :null => false
    t.string   "last_name",      :limit => 20,  :default => "",    :null => false
    t.string   "avatar",         :limit => 50,  :default => "",    :null => false
    t.integer  "privilegies",                   :default => 2
    t.integer  "raiting",                       :default => 0
    t.string   "password",       :limit => 32,  :default => "",    :null => false
    t.string   "crypt_password", :limit => 32,  :default => "",    :null => false
    t.boolean  "active",                        :default => false
    t.string   "code_activate",  :limit => 32
    t.datetime "birth_day"
    t.integer  "icq_number"
    t.string   "home_page",      :limit => 100
    t.string   "location",       :limit => 100
    t.string   "interests",      :limit => 100
    t.string   "job",            :limit => 100
    t.string   "description",                   :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["crypt_password"], :name => "users_crypt_password"
  add_index "users", ["email"], :name => "email", :unique => true
  add_index "users", ["email"], :name => "users_email"
  add_index "users", ["login"], :name => "login", :unique => true
  add_index "users", ["login"], :name => "users_login"

end
