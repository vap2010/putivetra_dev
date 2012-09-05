class CreateNodes < ActiveRecord::Migration
  def up
    create_table :nodes do |t|
      t.integer :project_id, :null => false
      t.string :nodeable_type
      t.integer :nodeable_id
      t.timestamps
    end
    add_index :nodes, :project_id
    add_index :nodes, :nodeable_id
  end

  def down
    drop_table :nodes
  end
end
