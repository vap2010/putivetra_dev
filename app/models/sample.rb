class Sample < ActiveRecord::Base
  belongs_to :batch
  validates :title, :batch_id, :presence => true
end
