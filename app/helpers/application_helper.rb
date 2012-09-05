module ApplicationHelper
  def top_brands
    links = []
    links << content_tag(:h4, "Выбор бренда", :class => "brands-well-header")
    links << link_to("Без бренда", "javascript://", :class => "btn", :rel => 0)
    links += Brand.all.sort_by {|p| p.title.mb_chars }.map do |p|
      link_to p.title, "javascript://", :class => "btn", :rel => p.id
    end
    content_tag :div, links.join.html_safe, :class => "well brands-well"
  end
end
