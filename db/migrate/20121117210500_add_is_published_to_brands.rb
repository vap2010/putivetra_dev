class AddIsPublishedToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :is_published, :boolean, :default => true, :null => false
  end
end
