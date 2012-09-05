module Linkable
  extend ActiveSupport::Concern

  included do
    has_one :link, :dependent => :destroy, :as => :linkable
    accepts_nested_attributes_for :link
  end
end
