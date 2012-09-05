class Batch < ActiveRecord::Base
  belongs_to :brand
  belongs_to :category
  validates :brand_id, :category_id, :title, :presence => true
  has_one :equipment_album, :class_name => "Album", :dependent => :destroy, :as => :albumable, :conditions => {:role => 'equipment'}
  has_one :optional_equipment_album, :class_name => "Album", :dependent => :destroy, :as => :albumable, :conditions => {:role => 'optional'}
  has_one :description_album, :class_name => "Album", :dependent => :destroy, :as => :albumable, :conditions => {:role => 'description'}
  has_many :samples, :dependent => :destroy

  before_create :build_equipment_album, :build_optional_equipment_album, :build_description_album
end
