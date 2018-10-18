require 'rscheme/atom'

class Pair < LObj
  def self.of_pair(p1, p2)
    new :pair, [p1, p2]
  end

  def car
    value[0]
  end

  def cdr
    value[1]
  end

  def nil?()
    value[0].type == :nil && value[1].type == :nil
  end

  def set_car(l)
    value[0] = l
  end

  def set_cdr(l)
    value[1] = l
  end
end

