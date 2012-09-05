class CreateMetaTags < ActiveRecord::Migration
  def up
    create_table :meta_tags do |t|
      t.text :title
      t.text :description
      t.text :keywords
      t.string :url
      t.integer :metatagable_id, :null => false
      t.string :metatagable_type, :null => false

      t.timestamps
    end
    add_index :meta_tags, [:metatagable_id, :metatagable_type], :uniq => true
  end

  def down
    drop_table :meta_tags
  end
end
