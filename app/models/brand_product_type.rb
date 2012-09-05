class BrandProductType < ActiveRecord::Base
  belongs_to :product_type
  belongs_to :brand
end
