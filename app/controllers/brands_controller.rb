class BrandsController < ApplicationController
  before_filter :find_meta_tag, :find_article, :find_selected_artcles, :only => [:page, :subpage]
  #before_filter :find_selected_categories,     :only => [:category, :subcategory]
  before_filter :page404, :only => [:page, :subpage]
  # after_filter  :skin_select,  :only => :page


  def page
    skin_select
  end

  def subpage
  end

  def katalog_index
    get_article(988)
    @meta_tag   = @article.meta_tag
    @categories = Category.roots[0].children.order('position').published
    @brands     = Brand.order('position').published
  end

  def katalog_db      ##  exp action
    get_article(988)
    @meta_tag   = @article.meta_tag
    @categories = Category.roots[0].children.order('position').published
    @brands     = Brand.order('position').published
  end

  def category
    @category = Category.find(params[:cat_id])
    @meta_tag = @category.meta_tag
    find_selected_categories
    select_category_brands(@category)        ######   @selected_items[1]
  end

  def subcategory
    @meta_tag = MetaTag.find_by_url(params[:id])
    common_subcategory                       ###      ???
  end 

  ######################################################################

  def brands_index
    @brands = Brand.order("position").published
    get_article(989)
    @meta_tag = @article.meta_tag
  end

  def brand_index
    @brand = Brand.find(params[:brand])
    get_article(@brand.article.id) if @brand.is_published
    @meta_tag = @article.meta_tag
    # SELECT `categories`.id FROM `categories` WHERE `categories`.`parent_id` = 5
    # c.child_ids
    @categories = Category.roots[0].children.order('position').published
  end

  def brand_category
  end

  def brand_subcategory
  end

  def brand_series
    @meta_tag = MetaTag.find_by_url(params[:series])
    if @meta_tag.metatagable_type == 'Batch'
      @batch    = @meta_tag.metatagable
      @category = @batch.category
      @brand    = @batch.brand
    else
      common_subcategory
      render :subcategory
    end
  end
 
  def brand_block
  end


  private

  def select_category_brands(cat)
    @brands = []
    add_category_brands(cat) if @selected_items[1]
    @brands.uniq!
  end

  def add_category_brands(cat)
    cat.batches.each do |b|
       @brands << b.brand unless !b.show_on_site and @brands.include? b.brand
    end
    cat.children.each do |c|
      add_category_brands(c)
    end
  end

  def common_subcategory
    @category = @meta_tag.metatagable
    find_selected_categories
    select_category_brands(@category)
    @batches  = @category.batches
  end

end
