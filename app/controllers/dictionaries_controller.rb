class DictionariesController < ApplicationController
  #before_filter :find_meta_tag, :find_article, :only => :show
  before_filter :find_meta_tag, :find_article, :except => :index
  before_filter :get_topmenu_points

  
  def slovar_index # :as => :slovar_index
    render :text => "slovar_index "
  end
  def slovar        # :as => :slovar_lang
    render :text => "slovar_lang #{params[:id]} "
  end
  def slovar_letter  # :as => :slovar_letter
    render :text => "slovar_letter #{params[:id]}  #{params[:letter]} "
  end
  def slovar_word    # :as => :slovar_word
    render :text => "slovar_word  #{params[:id]}   #{params[:letter]}   #{params[:word]} "
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
