class CreateAlbums < ActiveRecord::Migration
  def up
    create_table :albums do |t|
      t.string :title
      t.string :albumable_type, :null => false
      t.integer :albumable_id, :null => false
      t.integer :position, :null => false, :default => 1

      t.timestamps
    end
    add_index :albums, [:albumable_id, :albumable_type]
  end

  def down
    drop_table :albums
  end
end
