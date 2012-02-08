class CreatedAt < Dynasnip
  def handle(snip_name)
    if snip = app.soup[snip_name]
      snip.created_at.strftime("%B %d, %Y")
    end
  end
  self
end
