class CreateBrandRegions < ActiveRecord::Migration
  def up
    create_table :brand_regions do |t|
      t.integer :brand_id, :null => false
      t.integer :region_id, :null => false
      t.integer :position, :null => false, :default => 1

      t.timestamps
    end
    add_index :brand_regions, :brand_id
    add_index :brand_regions, :region_id
  end

  def down
    drop_table :brand_regions
  end
end
