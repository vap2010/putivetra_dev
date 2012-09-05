class CreatePriceFiles < ActiveRecord::Migration
  def change
    create_table :price_files do |t|
      t.string :title, :null => false
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps
    end
  end
end
