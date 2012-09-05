class AlbumFile < ActiveRecord::Base
  has_attached_file :attachment
  validates :title, :is_published, :position, :presence => true
  belongs_to :album
end
