class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :title, :null => false
      t.string :link

      t.timestamps
    end
  end
end
