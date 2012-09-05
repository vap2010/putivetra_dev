class ArticlesController < ApplicationController
  before_filter :find_meta_tag, :find_article, :only => :show

  def index
    @article = Article.find_by_parent_id(nil)
    @meta_tag = @article.meta_tag
  end

  def show
  end

  private
  def find_meta_tag
    @meta_tag = MetaTag.find_by_url(params[:id])
  end

  def find_article
    @article = @meta_tag.metatagable
  end
end
