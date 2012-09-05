class BrandFile < ActiveRecord::Base
  validates :title, :brand_id, :presence => true
  has_attached_file :attachment
end
