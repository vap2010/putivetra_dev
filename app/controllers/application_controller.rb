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
    
end
