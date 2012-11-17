class AddFieldsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :position, :integer, :default => 1, :null => false
    add_column :categories, :is_published,         :boolean, :default => true,  :null => false
    add_column :categories, :is_shown_in_menu,      :boolean, :default => false, :null => false
    add_column :categories, :are_children_published, :boolean, :default => true, :null => false
    add_column :categories, :unikey, :string
    add_column :categories, :skin_id, :integer
  end
end
