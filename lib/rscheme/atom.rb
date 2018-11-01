require 'rscheme/lobj'
require 'rscheme/rscheme_exception'

# ATOMオブジェクト
#
# @author tamura shingo
class Atom < LObj

  # 文字列のATOMを作成する
  # @param string [String] 文字列
  def self.of_string(string)
    new :string, string
  end

  # シンボルのATOMを作成する
  # @param symbol [String] シンボル（文字列であらわす）
  def self.of_symbol(symbol)
    new :symbol, symbol.upcase
  end

  # 値のATOMを作成する
  # @param value [Value] 値
  def self.of_value(value)
    new :value, value
  end

  # NULL値を作成する
  def self.of_nil()
    new :nil, ''
  end

  def nil?()
    @type == :nil
  end

  def car
    raise RschemeException, 'type error, expected pair but atom'
  end

  def cdr
    raise RschemeException, 'type error, expected pair but atom'
  end

end
