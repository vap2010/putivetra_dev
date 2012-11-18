class BrandsController < ApplicationController
  before_filter :find_meta_tag, :find_article, :find_selected_artcles, :only => [:page, :subpage]
  before_filter :page404, :only => [:page, :subpage]
  # after_filter  :skin_select,  :only => :page


  def page
    skin_select
  end

  def subpage
  end

  def katalog_index
  end

  def brands_index
    @brands = Brand.order("position")
    get_article(989)
  end

  def brand_index
    @brand = Brand.find(params[:brand])
    get_article(@brand.article.id)
  end

  def brand_category
  end

  def brand_subcategory
  end

  def brand_series
  end

  def brand_block
  end

end
