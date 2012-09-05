class BrandDistributor < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :brand
end
