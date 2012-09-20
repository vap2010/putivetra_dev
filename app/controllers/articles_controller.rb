class ArticlesController < ApplicationController
  #before_filter :find_meta_tag, :find_article, :only => :show
  before_filter :find_meta_tag, :find_article, :except => :index

  def index
    @article = Article.find_by_parent_id(nil)
    @meta_tag = @article.meta_tag
  end

  def show
  end

  def brand
    render :text => "ok - ok"
  end

  def novosti_index
    render :text => "novosti_index  #{novosti_index_path}" 
  end
  def novosti
    render :text => "novosti  x #{params[:id]} "
  end

  def rabota_index
    render :text => 'rabota_index'
  end
  def rabota
    render :text => "rabota  x #{params[:id]} "
  end

  def nashi_proekty_index
    render :text => 'nashi_proekty'
  end
  def nashi_proekty
    render :text => "nashi_proekty  x #{params[:id]} "
  end

  def otzivi_index
    render :text => 'otzivi_index'
  end
  def otzivi
    render :text => "otzivi  x #{params[:id]} "
  end

  def nagrady_index
    render :text => 'nagrady_index'
  end
  def nagrady
    render :text => "nagrady  x #{params[:id]} "
  end

  def akcii_index
    render :text => 'akcii_index'
  end
  def akcii
    render :text => "akcii  x #{params[:id]} "
  end









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
