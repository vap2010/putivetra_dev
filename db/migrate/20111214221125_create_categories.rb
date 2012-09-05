class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :title, :null => false
      t.integer :parent_id
      t.text :preview
      t.text :description

      t.timestamps
    end
    add_index :categories, :parent_id
  end

  def down
    drop_table :categories
  end
end
