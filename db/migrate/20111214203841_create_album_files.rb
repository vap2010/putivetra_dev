class CreateAlbumFiles < ActiveRecord::Migration
  def up
    create_table :album_files do |t|
      t.string :title, :null => false
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.integer :position, :null => false, :default => 1
      t.boolean :is_published, :null => false, :default => true
      t.integer :album_id, :null => false

      t.timestamps
    end
    add_index :album_files, :album_id
  end

  def down
    drop_table :album_files
  end
end
