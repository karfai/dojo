require 'treetop'

class SExpC < Treetop::Runtime::SyntaxNode
  def evaluate(interp)
    interp.send(func.text_value, args.elements().collect() { |el| el.inner.evaluate(interp) })
  end
end

class Number < Treetop::Runtime::SyntaxNode
  def evaluate(interp)
    interp.number(text_value)
  end
end
