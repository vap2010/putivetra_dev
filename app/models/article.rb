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
end
