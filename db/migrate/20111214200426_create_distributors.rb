class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors do |t|
      t.string :title, :null => false
      t.string :link

      t.timestamps
    end
  end
end
