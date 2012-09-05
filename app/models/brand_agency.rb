class BrandAgency < ActiveRecord::Base
  belongs_to :brand
  belongs_to :agency
end
