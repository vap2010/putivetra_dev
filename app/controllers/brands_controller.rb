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
    @meta_tag = @article.meta_tag
    @categories = Category.roots[0].children.order('position').published
    @brands = Brand.order('position').published
  end

  def katalog_db
    get_article(988)
    @meta_tag = @article.meta_tag
    @categories = Category.roots[0].children.order('position').published
    @brands = Brand.order('position').published
  end

  def category
    @category = Category.find(params[:cat_id])
    @meta_tag = @category.meta_tag
    find_selected_categories
    select_category_brands
  end

  def subcategory
    @meta_tag = MetaTag.find_by_url(params[:subcat])
    @category = @meta_tag.metatagable
    find_selected_categories
    select_category_brands
    @batches = @category.batches
  end



  def brands_index
    @brands = Brand.order("position").published
    get_article(989)
    @meta_tag = @article.meta_tag
  end

  def brand_index
    @brand = Brand.find(params[:brand])
    get_article(@brand.article.id) if @brand.is_published
    @meta_tag = @article.meta_tag
  end

  def brand_category
  end

  def brand_subcategory
  end

  def brand_series
  end

  def brand_block
  end


  private


  def select_category_brands
    @brands = []
    add_category_brands(@selected_items[1]) if @selected_items[1]
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



end
