class CreateProjectEvents < ActiveRecord::Migration
  def up
    create_table :project_events do |t|
      t.integer :project_id, :event_id, :null => false

      t.timestamps
    end
    add_index :project_events, :event_id
    add_index :project_events, :project_id
  end

  def down
    drop_table :project_events
  end
end
