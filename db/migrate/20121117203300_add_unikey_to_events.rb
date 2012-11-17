class AddUnikeyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :unikey, :string
  end
end
