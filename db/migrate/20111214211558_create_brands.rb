class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :title, :null => false
      t.string :logo_large_file_name
      t.string :logo_large_content_type
      t.integer :logo_large_file_size
      t.datetime :logo_large_updated_at
      t.string :logo_small_file_name
      t.string :logo_small_content_type
      t.integer :logo_small_file_size
      t.datetime :logo_small_updated_at

      t.string :foundation_year
      t.string :country
      t.string :speciality
      t.string :price_band
      t.text :preview, :description, :history
      t.boolean :is_dismissed, :null => false, :default => false
      t.string :manager_email
      t.timestamps
    end
  end
end
