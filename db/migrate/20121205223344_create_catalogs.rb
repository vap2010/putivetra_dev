class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.boolean :is_deleted, :default => false, :null => false
      t.boolean :is_published, :default => true, :null => false
      t.boolean :is_shown_in_menu, :default => false, :null => false
      t.integer :brand_id
      t.integer :position
      t.string :title,    :null => false
      t.string :file_name
      t.string :year
      t.text   :body
      t.timestamps
    end
  end
end
