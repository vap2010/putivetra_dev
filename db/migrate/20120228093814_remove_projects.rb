class RemoveProjects < ActiveRecord::Migration
  def up
    remove_column :articles, :project_id
    remove_column :nodes, :project_id
    drop_table :project_events
    drop_table :project_vacancies
    drop_table :projects
  end

  def down
    add_column :articles, :project_id, :integer, :null => false
    add_column :nodes, :project_id, :integer, :null => false
    create_table "project_events" do |t|
      t.integer  "project_id", :null => false
      t.integer  "event_id",   :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    create_table "project_vacancies" do |t|
      t.integer  "project_id", :null => false
      t.integer  "vacancy_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    create_table "projects" do |t|
      t.string   "title",      :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
