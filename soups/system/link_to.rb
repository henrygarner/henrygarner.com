require 'vanilla/dynasnip'

class LinkTo < Dynasnip
  usage %|
The link_to dyna lets you create links between snips: 

  {link_to blah} 

would insert a link to the blah snip.|

  def handle(name=nil, link_text=title, part=nil)
    return usage if requesting_this_snip?
    return "You must provide a snip name" unless name
    if app.soup[name]
      %{<a href="#{url_to(name, part)}">#{app.soup[name].title || name.to_s.capitalize}</a>}
    end
  end
  self
end