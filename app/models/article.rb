class Article < ActiveRecord::Base
  include Metatagable
  include Linkable
  belongs_to :parent, :class_name => 'Article'
  has_many :children, :class_name => 'Article', :order => 'position', :foreign_key => :parent_id, :dependent => :destroy
  validates :title, :presence => true

  class << self
    def roots
      where(:parent_id => nil)
    end
  end

  def url
    '/' + meta_tag.url + '.html'
  end

  def show_on_site
    is_published and !is_deleted
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
