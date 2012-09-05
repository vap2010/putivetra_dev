class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :title, :null => false
      t.string :group, :variance, :value, :unit
      t.timestamps
    end
  end
end
