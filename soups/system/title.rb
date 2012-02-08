require 'vanilla/dynasnip'

class Title < Dynasnip
  def handle
    app.request.snip.title || app.request.snip.name
  end
  self
end