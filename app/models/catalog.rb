class Catalog < ActiveRecord::Base
  validates :title, :presence => true
  belongs_to :brand

end
