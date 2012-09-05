class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string :title, :null => false
      t.timestamps
    end
  end
end
