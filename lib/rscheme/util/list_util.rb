require 'rscheme/atom'
require 'rscheme/pair'

module ListUtil
  
  def self.copy(list)
    src = list
    start = Pair.of_pair Atom.of_nil, Atom.of_nil
    current = start
    loop do
      if src.nil?
        return start
      else
        current.set_car src.car
        cdr = Pair.of_pair Atom.of_nil, Atom.of_nil
        current.set_cdr cdr
        src = src.cdr
        current = cdr
      end
    end
  end

  def self.append(l1, l2)
    if l1.nil?
      return copy l2
    else
      start = copy l1
      p = start
      loop do
        if p.cdr.nil?
          p.set_cdr l2
          return start
        else
          p = p.cdr
        end
      end
    end
  end

  # リストが指定されたタグで開始しているかをチェックする
  #
  # @param exp [LObj] リスト
  # @param tag [string] タグ
  #
  def self.tagged_list(exp, tag)
    exp.type == :pair && exp.car.value == tag
  end

end
