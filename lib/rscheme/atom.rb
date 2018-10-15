require 'rscheme/lobj'

# ATOMオブジェクト
#
# @author tamura shingo
class Atom < LObj

  # 文字列のATOMを作成する
  # @param string [String] 文字列
  def self.ofString(string)
    new :string, string
  end

  # シンボルのATOMを作成する
  # @param symbol [String] シンボル（文字列であらわす）
  def self.ofSymbol(symbol)
    new :symbol, symbol.upcase
  end

  # 値のATOMを作成する
  # @param value [Value] 値
  def self.ofValue(value)
    new :value, value
  end
end

