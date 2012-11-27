class Brand < ActiveRecord::Base
  include Metatagable
#  include Linkable
  has_attached_file :logo_large
  has_attached_file :logo_small
  validates :title, :presence => true
  has_many :brand_product_type, :dependent => :destroy
  has_many :product_type, :through => :brand_product_type
  has_many :brand_regions, :dependent => :destroy
  has_many :regions, :through => :brand_regions
  has_many :brand_agencies, :dependent => :destroy
  has_many :agencies, :through => :brand_agencies
  has_many :brand_distributors, :dependent => :destroy
  has_many :distributors, :through => :brand_distributors
  has_many :brand_files, :dependent => :destroy
  has_many :price_files, :dependent => :destroy
  belongs_to :article
  scope :published, where(:is_published => true)

  def speciality_enum
    ['low', 'medium', 'high']
  end

  def price_band_enum
    ['low', 'medium', 'high']
  end

  def url
    '/' + meta_tag.url.downcase.to_s.gsub(/^_*/, '') + '.html'
  end

  def show_on_site
    is_published     # and !is_deleted
  end

  def show_in_menu
    is_shown_in_menu and show_on_site
  end

end
