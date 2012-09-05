class CreateBrandAgencies < ActiveRecord::Migration
  def up
    create_table :brand_agencies do |t|
      t.integer :brand_id, :null => false
      t.integer :agency_id, :null => false
      t.integer :position, :null => false, :default => 1

      t.timestamps
    end
    add_index :brand_agencies, :brand_id
    add_index :brand_agencies, :agency_id
  end

  def down
    drop_table :brand_agencies
  end
end
