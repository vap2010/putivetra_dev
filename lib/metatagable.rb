module Metatagable
  extend ActiveSupport::Concern

  included do
    has_one :meta_tag, :dependent => :destroy, :as => :metatagable
    accepts_nested_attributes_for :meta_tag
  end
end

