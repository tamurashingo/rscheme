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
end

