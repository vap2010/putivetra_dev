module ArticlesHelper
  def article_submenu article
    content_tag :ul do
      article.children.map do |child|
        content_tag :li, link_to(child.title, article_url(child))
      end.join.html_safe
    end
  end

  def article_title meta_tag
    meta_tag.try :title
  end

  def article_description meta_tag
    meta_tag.try :description
  end

  def article_keywords meta_tag
    meta_tag.try :keywords
  end

  def article_parent article
    content_tag(:p) do
      "Parent: ".html_safe +
      link_to(article.parent.title, article_url(article.parent))
    end if article.parent_id?
  end

  def article_url article
    "/#{article.meta_tag.url}"
  end
end
