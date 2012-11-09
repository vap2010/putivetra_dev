class AddUnikeyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :unikey, :string
  end
end
