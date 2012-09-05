class AddFieldsToMetaTags < ActiveRecord::Migration
  def change
    add_column :meta_tags, :noindex, :boolean, :null => false, :default => false
    add_column :meta_tags, :nofollow, :boolean, :null => false, :default => false
  end
end
