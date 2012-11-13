class ApplicationController < ActionController::Base
  protect_from_forgery



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

  def get_topmenu_points
     @topmenu_points = Article.find([987, 988, 989, 990, 991, 992, 1002])
     @topmenu_points << Article.find(994)
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


end
