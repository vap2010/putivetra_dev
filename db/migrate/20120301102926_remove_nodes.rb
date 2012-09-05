class RemoveNodes < ActiveRecord::Migration
  def up
    drop_table :nodes
  end

  def down
    create_table "nodes" do |t|
      t.string   "nodeable_type"
      t.integer  "nodeable_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "ancestry"
    end
    add_index "nodes", ["ancestry"], :name => "index_nodes_on_ancestry"
    add_index "nodes", ["nodeable_id"], :name => "index_nodes_on_nodeable_id"
  end
end
