class AddBrandIdToBrandFilesAndPriceFiles < ActiveRecord::Migration
  def change
    add_column :brand_files, :brand_id, :integer, :null => false
    add_column :price_files, :brand_id, :integer, :null => false
  end
end
