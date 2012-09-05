class Feature < ActiveRecord::Base
  validates :title, :presence => true
end
