class MetaTag < ActiveRecord::Base
  belongs_to :metatagable, :polymorphic => true
  validates :url, :presence => true, :uniqueness => true
end
