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

ActiveRecord::Schema.define(:version => 20120301111227) do

  create_table "agencies", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "album_files", :force => true do |t|
    t.string   "title",                                     :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "position",                :default => 1,    :null => false
    t.boolean  "is_published",            :default => true, :null => false
    t.integer  "album_id",                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "album_files", ["album_id"], :name => "index_album_files_on_album_id"

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.string   "albumable_type",                :null => false
    t.integer  "albumable_id",                  :null => false
    t.integer  "position",       :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "albums", ["albumable_id", "albumable_type"], :name => "index_albums_on_albumable_id_and_albumable_type"

  create_table "articles", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "skin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",               :default => 1,     :null => false
    t.boolean  "is_deleted",             :default => false, :null => false
    t.boolean  "is_published",           :default => true,  :null => false
    t.boolean  "are_children_published", :default => true,  :null => false
    t.boolean  "is_shown_in_menu",       :default => false, :null => false
    t.boolean  "is_preview_published",   :default => false, :null => false
    t.string   "title",                                     :null => false
    t.text     "preview"
    t.text     "body"
  end

  add_index "articles", ["parent_id"], :name => "index_articles_on_parent_id"

  create_table "batches", :force => true do |t|
    t.integer  "brand_id",     :null => false
    t.integer  "category_id",  :null => false
    t.string   "title",        :null => false
    t.string   "labeling"
    t.string   "range"
    t.text     "description"
    t.text     "preview"
    t.text     "params_short"
    t.text     "params_full"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batches", ["brand_id"], :name => "index_batches_on_brand_id"
  add_index "batches", ["category_id"], :name => "index_batches_on_category_id"

  create_table "brand_agencies", :force => true do |t|
    t.integer  "brand_id",                  :null => false
    t.integer  "agency_id",                 :null => false
    t.integer  "position",   :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_agencies", ["agency_id"], :name => "index_brand_agencies_on_agency_id"
  add_index "brand_agencies", ["brand_id"], :name => "index_brand_agencies_on_brand_id"

  create_table "brand_distributors", :force => true do |t|
    t.integer  "brand_id",                      :null => false
    t.integer  "distributor_id",                :null => false
    t.integer  "position",       :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_distributors", ["brand_id"], :name => "index_brand_distributors_on_brand_id"
  add_index "brand_distributors", ["distributor_id"], :name => "index_brand_distributors_on_distributor_id"

  create_table "brand_files", :force => true do |t|
    t.string   "title",                   :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id",                :null => false
  end

  create_table "brand_product_types", :force => true do |t|
    t.integer  "product_type_id",                :null => false
    t.integer  "brand_id",                       :null => false
    t.integer  "position",        :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_product_types", ["brand_id"], :name => "index_brand_product_types_on_brand_id"
  add_index "brand_product_types", ["product_type_id"], :name => "index_brand_product_types_on_product_type_id"

  create_table "brand_regions", :force => true do |t|
    t.integer  "brand_id",                  :null => false
    t.integer  "region_id",                 :null => false
    t.integer  "position",   :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "brand_regions", ["brand_id"], :name => "index_brand_regions_on_brand_id"
  add_index "brand_regions", ["region_id"], :name => "index_brand_regions_on_region_id"

  create_table "brands", :force => true do |t|
    t.string   "title",                                      :null => false
    t.string   "logo_large_file_name"
    t.string   "logo_large_content_type"
    t.integer  "logo_large_file_size"
    t.datetime "logo_large_updated_at"
    t.string   "logo_small_file_name"
    t.string   "logo_small_content_type"
    t.integer  "logo_small_file_size"
    t.datetime "logo_small_updated_at"
    t.string   "foundation_year"
    t.string   "country"
    t.string   "speciality"
    t.string   "price_band"
    t.text     "preview"
    t.text     "description"
    t.text     "history"
    t.boolean  "is_dismissed",            :default => false, :null => false
    t.string   "manager_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "title",       :null => false
    t.integer  "parent_id"
    t.text     "preview"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "distributors", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "skin_id"
    t.boolean  "is_deleted",           :default => false, :null => false
    t.boolean  "is_published",         :default => true,  :null => false
    t.boolean  "is_shown_in_menu",     :default => false, :null => false
    t.boolean  "is_preview_published", :default => false, :null => false
    t.string   "title",                                   :null => false
    t.text     "preview"
    t.text     "body"
    t.datetime "published_at",                            :null => false
    t.datetime "published_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "group"
    t.string   "variance"
    t.string   "value"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "linkable_id",   :null => false
    t.string   "linkable_type", :null => false
    t.string   "linkage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["linkable_id", "linkable_type"], :name => "index_links_on_linkable_id_and_linkable_type"

  create_table "meta_tags", :force => true do |t|
    t.text     "title"
    t.text     "description"
    t.text     "keywords"
    t.string   "url"
    t.integer  "metatagable_id",                      :null => false
    t.string   "metatagable_type",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "noindex",          :default => false, :null => false
    t.boolean  "nofollow",         :default => false, :null => false
  end

  add_index "meta_tags", ["metatagable_id", "metatagable_type"], :name => "index_meta_tags_on_metatagable_id_and_metatagable_type"

  create_table "price_files", :force => true do |t|
    t.string   "title",                   :null => false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id",                :null => false
  end

  create_table "product_types", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "regions", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", :force => true do |t|
    t.string   "title",       :null => false
    t.integer  "batch_id",    :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "samples", ["batch_id"], :name => "index_samples_on_batch_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vacancies", :force => true do |t|
    t.integer  "skin_id"
    t.integer  "position",             :default => 1,     :null => false
    t.boolean  "is_deleted",           :default => false, :null => false
    t.boolean  "is_published",         :default => true,  :null => false
    t.boolean  "is_shown_in_menu",     :default => false, :null => false
    t.boolean  "is_preview_published", :default => false, :null => false
    t.string   "title",                                   :null => false
    t.text     "preview"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
