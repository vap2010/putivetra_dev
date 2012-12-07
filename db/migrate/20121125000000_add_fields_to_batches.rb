class AddFieldsToBatches < ActiveRecord::Migration
  def change
    add_column :batches, :skin_id,              :integer
    add_column :batches, :position,             :integer,  :default => 1,     :null => false
    add_column :batches, :is_deleted,           :boolean,  :default => false, :null => false
    add_column :batches, :is_published,         :boolean,  :default => true,  :null => false
    add_column :batches, :is_shown_in_menu,     :boolean,  :default => true,  :null => false
    add_column :batches, :is_preview_published, :boolean,  :default => false, :null => false
    add_column :batches, :title_prefix,        :string
    add_column :batches, :block_type_inner,    :string
    add_column :batches, :block_type_outer,    :string
    add_column :batches, :catalog_id,        :integer
    add_column :batches, :unikey,              :string
  end
end
