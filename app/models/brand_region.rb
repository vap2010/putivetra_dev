class BrandRegion < ActiveRecord::Base
  belongs_to :brand
  belongs_to :region
end
