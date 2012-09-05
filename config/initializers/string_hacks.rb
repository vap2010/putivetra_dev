require 'builder/xmlbase'
module Builder
  class XmlBase < BlankSlate
    def _escape(text)
      if (text.method(:to_xs).arity == 0)
        text.to_xs
      else
        text.to_xs((@encoding != 'utf-8' or $KCODE != 'UTF8'))
      end
    end
  end
end
