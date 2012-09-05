class CreateBrandDistributors < ActiveRecord::Migration
  def up
    create_table :brand_distributors do |t|
      t.integer :brand_id, :null => false
      t.integer :distributor_id, :null => false
      t.integer :position, :null => false, :default => 1

      t.timestamps
    end
    add_index :brand_distributors, :brand_id
    add_index :brand_distributors, :distributor_id
  end

  def down
    drop_table :brand_distributors
  end
end
