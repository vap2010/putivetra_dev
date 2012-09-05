class CreateBrandProductTypes < ActiveRecord::Migration
  def up
    create_table :brand_product_types do |t|
      t.integer :product_type_id, :null => false
      t.integer :brand_id, :null => false
      t.integer :position, :null => false, :default => 1

      t.timestamps
    end
    add_index :brand_product_types, :brand_id
    add_index :brand_product_types, :product_type_id
  end

  def down
    drop_table :brand_product_types
  end
end
