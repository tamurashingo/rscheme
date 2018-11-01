# Lispオブジェクト
# 
# @author tamura shingo
#
module Rscheme
  class LObj
    # コンストラクタ
    # @param type [Symbol] オブジェクトの種別
    # @param value [any] 値
    def initialize(type, value)
      @type = type
      @value = value
    end

    # 種別を返す
    # @return [Symbol] 種別
    def type
      @type
    end

    # 値を返す
    # @return [any] 値
    def value
      @value
    end
  end
end
