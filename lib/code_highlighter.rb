require 'coderay'
class CodeHighlighter < Dynasnip
  def handle(language, part_to_render='content')
    text = enclosing_snip.__send__(part_to_render.to_sym)
    CodeRay.scan(text, 'ruby').div(:css => :class)
  end
end
