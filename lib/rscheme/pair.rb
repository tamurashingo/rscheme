require 'rscheme/atom'

class Pair < LObj
  def self.ofPair(p1, p2)
    new :pair, [p1, p2]
  end

  def car
    value[0]
  end

  def cdr
    value[1]
  end

  def isNil()
    value[0].type == :nil && value[1].type == :nil
  end

  def setCar(l)
    value[0] = l
  end

  def setCdr(l)
    value[1] = l
  end
end

