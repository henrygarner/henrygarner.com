class Youtube < Dynasnip
  def handle(id)
    "<iframe width=\"420\" height=\"315\" src=\"http://www.youtube.com/embed/#{id}\" frameborder=\"0\" allowfullscreen></iframe>"
  end
  self
end
