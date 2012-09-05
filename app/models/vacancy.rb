class Vacancy < ActiveRecord::Base
  include Metatagable
  validates :title, :presence => true
end
