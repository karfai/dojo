class Interpreter
  def add(vals)
    rv = 0
    vals.each() { |v| rv += v }
    rv
  end

  def sub(vals)
    rv = 0
    if vals.length() > 1
      rv = vals[0]
      vals[1..-1].each() { |v| rv -= v }
    else
      rv -= vals[0]
    end
    rv
  end

  def mul(vals)
    rv = 1
    vals.each() { |v| rv *= v }
    rv
  end

  def div(vals)
    rv = 'nil'
    if vals.length > 1
      rv = vals[0]
      vals[1..-1].each() { |v| rv /= v }
    end
    rv
  end

  def list(vals)
    vals
  end

  def car(vals)
    vals[0][0]
  end

  def cdr(vals)
    vals[0][1..-1]
  end

  def number(val)
    val.to_i
  end
end
