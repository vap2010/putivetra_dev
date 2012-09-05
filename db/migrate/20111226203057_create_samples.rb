class CreateSamples < ActiveRecord::Migration
  def up
    create_table :samples do |t|
      t.string :title, :null => false
      t.integer :batch_id, :null => false
      t.text :description
      t.timestamps
    end
    add_index :samples, :batch_id
  end

  def down
    drop_table :samples
  end
end
