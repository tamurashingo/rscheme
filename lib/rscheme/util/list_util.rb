require 'rscheme/atom'
require 'rscheme/pair'

class ListUtil
  
  def self.copy(list)
    src = list
    start = Pair.ofPair Atom.ofNil, Atom.ofNil
    current = start
    loop do
      if src.isNil
        return start
      else
        current.setCar src.car
        cdr = Pair.ofPair Atom.ofNil, Atom.ofNil
        current.setCdr cdr
        src = src.cdr
        current = cdr
      end
    end
  end

  def self.append(l1, l2)
    if l1.isNil
      return copy l2
    else
      start = copy l1
      p = start
      loop do
        if p.cdr.isNil
          p.setCdr l2
          return start
        else
          p = p.cdr
        end
      end
    end
  end
end
