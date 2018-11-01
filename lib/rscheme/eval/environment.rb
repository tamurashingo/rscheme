require 'rscheme/rscheme_exception'
require 'rscheme/util/scheme_list_iterator'

module Rscheme
  class Environment
    attr_reader :variables

    def self.create_global()
      Environment.new nil
    end

    def initialize(parent)
      @parent = parent
      @variables = Hash.new
    end

    def set_variable(symbol, value)
      env = lookup_environment symbol
      if env
        env.store symbol, value
      else
        store symbol, value
      end
    end

    def lookup_environment(symbol)
      if @variables.has_key? symbol
        self
      else
        if @parent
          @parent.lookup_environment symbol
        else
          nil
        end
      end
    end

    def store(symbol, value)
      @variables.store symbol, value
    end

    # 変数名
    #
    # @param symbol [string] 
    def lookup(symbol)
      if @variables.has_key? symbol
        @variables[symbol]
      else
        if @parent
          @parent.lookup symbol
        else
          raise RschemeException, 'not found variable:' + symbol
        end
      end
    end

    # 現在の環境をもとに新しい環境を作成し、引数とその値を環境にセットする
    #
    # @param vars [pair] 引数のリスト(変数名のリスト)
    # @param vals [pair] 値のリスト
    # @returns 現在の環境を拡張し、引数と値がセットされた環境
    def extend_environment(vars, vals)
      env = Environment.new self
      vars_it = SchemeListIterator.new vars
      vals_it = SchemeListIterator.new vals

      while vars_it.has_next? && vals_it.has_next?
        var = vars_it.next.value
        val = vals_it.next
        env.store var, val
      end

      env
    end
  end
end

