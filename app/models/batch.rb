class Batch < ActiveRecord::Base
  belongs_to :brand
  belongs_to :category
  belongs_to :catalog
  validates :brand_id, :category_id, :title, :presence => true
  has_one :equipment_album, :class_name => "Album", :dependent => :destroy, :as => :albumable, :conditions => {:role => 'equipment'}
  has_one :optional_equipment_album, :class_name => "Album", :dependent => :destroy, :as => :albumable, :conditions => {:role => 'optional'}
  has_one :description_album, :class_name => "Album", :dependent => :destroy, :as => :albumable, :conditions => {:role => 'description'}
  has_many :samples, :dependent => :destroy

  before_create :build_equipment_album, :build_optional_equipment_album, :build_description_album
  include Metatagable
  scope :published, where(:is_published => true)


  def url
    url = '/' + brand.meta_tag.url.downcase.to_s.gsub(/^_*/, '') 
    url += category.parent_url(category) + '/' + meta_tag.url.downcase + '.html'
  end


  def show_on_site
    is_published     # and !is_deleted
  end

  def show_in_menu
    is_shown_in_menu and show_on_site
  end

  def show_childrens_on_site
    are_children_published and show_on_site
  end

  def show_childrens_in_menu
    is_shown_in_menu and show_childrens_on_site
  end


end
