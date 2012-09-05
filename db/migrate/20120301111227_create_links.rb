class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer "linkable_id", :null => false
      t.string "linkable_type", :null => false
      t.string "linkage"
      t.timestamps
    end
    add_index :links, ["linkable_id", "linkable_type"]
  end
end
