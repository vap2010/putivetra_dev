class Distributor < ActiveRecord::Base
  validates :title, :presence => true
  has_many :brand_distributors, :dependent => :destroy
  has_many :brands, :through => :brand_distributors
end
