class Event < ActiveRecord::Base
  include Metatagable
  validates :title, :presence => true
end
