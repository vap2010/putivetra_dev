class CreateVacancies < ActiveRecord::Migration
  def up
    create_table :vacancies do |t|
      t.integer :skin_id
      t.integer :position, :null => false, :default => 1
      t.boolean :is_deleted, :null => false, :default => false
      t.boolean :is_published, :default => true, :null => false
      t.boolean :is_shown_in_menu, :default => false, :null => false
      t.boolean :is_preview_published, :default => false, :null => false
      t.string :title, :null => false
      t.text :preview, :body
      t.timestamps
    end
  end

  def down
    drop_table :vacancies
  end
end
