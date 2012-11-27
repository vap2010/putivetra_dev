class Category < ActiveRecord::Base
  has_one :album, :dependent => :destroy, :as => :albumable
  belongs_to :parent, :class_name => 'Category'
  has_many :children, :class_name => 'Category', :foreign_key => :parent_id
  has_many :batches, :dependent => :destroy
  include Metatagable

  before_create :build_album
  scope :published, where(:is_published => true)
  

  class << self
    def roots
      where(:parent_id => nil)
    end
  end

  def brand_url (brand)
    brand = Brand.find(brand) if(brand.kind_of? Numeric)
    '/' + brand.meta_tag.url.downcase + url
  end

  def url
    parent_url(self) + '.html'
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

  def parent_url(cat)
    purl = if cat.parent and cat.parent.id > 1 then parent_url(cat.parent) else '' end
    url = purl + '/' + cat.meta_tag.url.downcase
  end


  private





end
