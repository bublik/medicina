class Initialize < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string    "login",          :limit => 15,  :default => "",    :null => false
      t.string    "email",          :limit => 50,  :default => "",    :null => false
      t.string    "first_name",     :limit => 20,  :default => "",    :null => false
      t.string    "last_name",      :limit => 20,  :default => "",    :null => false
      t.string    "avatar",         :limit => 50,  :default => "",    :null => false
      t.integer   "privilegies",                   :default => 2
      t.integer   "raiting",                       :default => 0
      t.string    "password",       :limit => 32,  :default => "",    :null => false
      t.string    "crypt_password", :limit => 32,  :default => "",    :null => false
      t.boolean   "active",                        :default => false
      t.string    "code_activate",  :limit => 32
      t.timestamp "birth_day"
      t.integer   "icq_number"
      t.string    "home_page",      :limit => 100
      t.string    "location",       :limit => 100
      t.string    "interests",      :limit => 100
      t.string    "job",            :limit => 100
      t.string    "description",                   :default => ""
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "users", ["login"], :name => "login", :unique => true
    add_index "users", ["email"], :name => "email", :unique => true
    add_index "users", ["login"], :name => "users_login"
    add_index "users", ["email"], :name => "users_email"
    add_index "users", ["crypt_password"], :name => "users_crypt_password"
    
    #Create admin 
    # login admin password admin  
    u = User.create(:login => 'admin', :password => 'admin', :email => 'rebisall@gmail.com', :code_activate => "39b3cc704b35f890a3b16c20ec54608d")
    u.update_attributes({:active => true, :privilegies => 1})

    create_table "categories", :force => true do |t|
      t.string "name",       :null => false
      t.string "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    Category.create("name" => 'default category', "title" => 'title for default category')

    create_table "posts", :force => true do |t|
      t.integer  "user_id"
      t.integer  "category_id", :null => true
      t.string   "title"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "posts", ["user_id", 'category_id'], :name => "posts_user_categ_ind"

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

    add_index "attachments", ["post_id", 'parent_id'], :name => "attachmet_post_ind"
        
    create_table "bcomments", :force => true do |t|
      t.integer  "user_id"
      t.integer  "post_id"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "bcomments", ["user_id", 'post_id'], :name => "bcommen_user_post_ind"
    

  end

  def self.down
    drop_table "attachments"
    drop_table "bcomments"
    drop_table "categories"
    drop_table "posts"
    drop_table "users"
  end
end
