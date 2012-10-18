class ApplicationController < ActionController::Base
  protect_from_forgery



  private
  
  def find_meta_tag
    @meta_tag = MetaTag.find_by_url(params[:id])
  end

  def find_article
    @article = @meta_tag.metatagable
   rescue
    @article = Article.new
  end

  def find_selected_artcles
    @selected_items = []
    add_parent_item(@article) if @article and !@article.new_record?
    @selected_items
  end

  def add_parent_item(item)
    if item.parent
      @selected_items.unshift(item)
      add_parent_item(item.parent)
    end  
  end


    
end
