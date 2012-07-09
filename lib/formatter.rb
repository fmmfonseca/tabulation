require 'formatter/html'

##
# Serialize a Tabulation.
#
class Formatter

  def initialize(tabulation)
    @tabulation = tabulation
  end
  
  def to_html
    HTML.render(@tabulation)
  end

end