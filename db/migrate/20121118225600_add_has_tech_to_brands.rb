class AddHasTechToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :article_id, :integer
    add_column :brands, :has_cond, :boolean
    add_column :brands, :has_vent, :boolean
  end
end
