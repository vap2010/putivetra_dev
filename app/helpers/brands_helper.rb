module BrandsHelper
  def technic_type_name(pref, brand)
    tych = ''
    if pref
      tych += ' - ' if brand.has_cond or brand.has_vent
    end  
    if brand.has_cond
      tych += 'КОНДИЦИОНЕРЫ'
      tych += ' И '      if brand.has_vent
    end
    tych += 'ВЕНТИЛЯЦИЯ' if brand.has_vent
    tych
  end
end
