class Gist < Dynasnip
  def handle(id)
    "<script src=\"http://gist.github.com/#{id}.js\"></script>"
  end
  self
end
