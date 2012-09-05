#= require jquery.cookie

$ ->
  $brands = $(".brands-well .btn")
  selectBrand = (id) ->
    $brands.removeClass("primary")
    $brands.filter($("*[rel=\"#{id}\"]")).addClass("primary")
    $.cookie('brand', id)
  val = $.cookie('brand') || 0
  selectBrand(val)
  $brands.click(->
    selectBrand($(this).attr("rel"))
    document.location.reload()
  )

