require 'rscheme/atom'

module Rscheme
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

    def to_s
      s = '('
      s << to_s_internal(self)
      s << ')'
      s
    end

    def to_s_internal(obj)
      buf = ''
      if obj.nil?
        buf << obj.to_s
      elsif obj.type == :pair
        buf << obj.car.to_s
        if obj.cdr.nil?
          # cdrがNILなら何もしない
        elsif obj.cdr.type == :pair
          # cdrがpairならリストで表現する
          buf << ' '
          buf << to_s_internal(obj.cdr)
        else
          # cdrがatomならドットで表現する
          buf << ' . '
          buf << to_s_internal(obj.cdr)
        end
      else
        # atom
        buf << obj.to_s
      end
      buf
    end
  end
end
