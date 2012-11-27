class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :get_topmenu_points
  

  private
  
  def find_meta_tag
    @meta_tag = MetaTag.find_by_url(params[:id])
  end

  def find_article
    @article = @meta_tag.metatagable
    unless @article.is_published                      # ввести проверки 
      redirect_to '/page404.html', :status => 404
    end
   rescue
    @article = Article.new
  end

  def find_selected_artcles
    @selected_items = []
    @selected_items_ids = []
    add_parent_item(@article) if @article and !@article.new_record?
    @selected_items
  end

  def add_parent_item(item)
    if item.parent
      @selected_items.unshift(item)
      @selected_items_ids.unshift(item.id)
      add_parent_item(item.parent)
    end
  end

  def find_selected_categories
    @selected_items = []
    @selected_items_ids = []
    add_parent_item(@category) if @category and !@category.new_record?
    @selected_items.unshift(Category.roots[0])
  end


  def get_topmenu_points
     @topmenu_points = Article.find([987, 988, 989, 990, 991, 992, 1002])
     @topmenu_points << Article.find(994)
     ## @topmenu_points[2].meta_tag.url = 'firmy_i_brendi' ## хак не нужен
  end

  def page404
    unless @article.id
      redirect_to '/page404.html', :status => 404 
    end
  end

  def skin_select
    if @article.skin_id == 1
      render :subpage
    end
  end

  def get_article(article_id)
    @article = Article.find(article_id)
    @meta_tag = @article.meta_tag
    find_selected_artcles
    page404
  end


end
