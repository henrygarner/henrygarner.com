require "vanilla/dynasnip"

class Feed < Dynasnip
  def handle(*args)
    app.atom_feed({
      :domain => "henrygarner.com",
      :title => "Henry Garner",
      :matching => {:kind => "blog"}
    })
  end
  self
end