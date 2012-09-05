class AddRoleToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :role, :string
  end
end
