class Album < ActiveRecord::Base
  validates :albumable_type, :albumable_id, :presence => true
  has_many :album_files, :dependent => :destroy
  belongs_to :albumable, :polymorphic => true
end
