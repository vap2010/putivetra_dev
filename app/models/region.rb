class Region < ActiveRecord::Base
  validates :title, :presence => true
  has_many :brand_regions, :dependent => :destroy
  has_many :brands, :through => :brand_regions
end
