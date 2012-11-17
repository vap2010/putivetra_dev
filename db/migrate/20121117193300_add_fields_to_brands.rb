class AddFieldsToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :position, :integer, :default => 1, :null => false
    add_column :brands, :is_shown_in_menu, :boolean, :default => false, :null => false
    add_column :brands, :unikey, :string
    add_column :brands, :skin_id, :integer
  end
end
