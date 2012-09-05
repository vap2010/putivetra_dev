class CreateBatches < ActiveRecord::Migration
  def up
    create_table :batches do |t|
      t.integer :brand_id, :null => false
      t.integer :category_id, :null => false
      t.string :title, :null => false
      t.string :labeling, :range
      t.text :description, :preview
      t.text :params_short, :params_full
      t.timestamps
    end
    add_index :batches, :category_id
    add_index :batches, :brand_id
  end

  def down
    drop_table :batches
  end
end
