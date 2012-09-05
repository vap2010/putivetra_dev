class Agency < ActiveRecord::Base
  validates :title, :presence => true
  has_many :brand_agencies, :dependent => :destroy
  has_many :brands, :through => :brand_agencies
end
