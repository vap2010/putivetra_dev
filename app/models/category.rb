class Category < ActiveRecord::Base
  has_one :album, :dependent => :destroy, :as => :albumable
  belongs_to :parent, :class_name => 'Category'
  has_many :children, :class_name => 'Category', :foreign_key => :parent_id
  has_many :batches, :dependent => :destroy

  before_create :build_album

  class << self
    def roots
      where(:parent_id => nil)
    end
  end
end
