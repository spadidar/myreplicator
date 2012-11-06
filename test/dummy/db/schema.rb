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

ActiveRecord::Schema.define(:version => 20121101005152) do

  create_table "myreplicator_exports", :force => true do |t|
    t.string   "source_schema"
    t.string   "destination_schema"
    t.string   "table_name"
    t.string   "incremental_column"
    t.string   "max_incremental_value"
    t.string   "incremental_column_type"
    t.string   "export_to",               :default => "destination_db"
    t.string   "export_type",             :default => "incremental"
    t.string   "s3_path"
    t.string   "cron"
    t.datetime "last_run"
    t.string   "state"
    t.string   "error"
    t.boolean  "active",                  :default => true
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "myreplicator_exports", ["source_schema", "destination_schema", "table_name"], :name => "unique_index", :unique => true

end
