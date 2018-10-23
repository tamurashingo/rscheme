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

  def self.list(*objs)
    pair = Pair.of_pair Atom.of_nil, Atom.of_nil
    start = pair
    objs.each_with_index do |o, idx|
      pair.set_car o
      if idx != objs.length - 1
        r = Pair.of_pair Atom.of_nil, Atom.of_nil
        pair.set_cdr r
        pair = r
      end
    end
    start
  end

  def self.first_list(exp)
    exp.car
  end

  def self.rest_list(exp)
    exp.cdr
  end

  def self.last?(exp)
    exp.cdr.nil?
  end
end
