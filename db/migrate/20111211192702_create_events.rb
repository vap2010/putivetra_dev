class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :skin_id
      t.boolean :is_deleted, :default => false, :null => false
      t.boolean :is_published, :default => true, :null => false
      t.boolean :is_shown_in_menu, :default => false, :null => false
      t.boolean :is_preview_published, :default => false, :null => false
      t.string :title, :null => false
      t.text :preview, :body
      t.datetime :published_at, :null => false
      t.datetime :published_until

      t.timestamps
    end
  end
end
