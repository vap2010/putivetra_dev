class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.integer :parent_id, :skin_id
      t.timestamps
      t.integer :project_id, :null => false
      t.integer :position, :null => false, :default => 1
      t.boolean :is_deleted, :default => false, :null => false
      t.boolean :is_published, :default => true, :null => false
      t.boolean :are_children_published, :default => true, :null => false
      t.boolean :is_shown_in_menu, :default => false, :null => false
      t.boolean :is_preview_published, :default => false, :null => false
      t.string :title, :null => false
      t.text :preview, :body
    end
    add_index :articles, :parent_id
    add_index :articles, :project_id
  end

  def down
    drop_table :articles
  end
end
