require 'rscheme/rscheme_exception'

class Environment
  attr_reader :variables

  def self.create_global()
    Environment.new nil
  end

  def initialize(parent)
    @parent = parent
    @variables = Hash.new
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
end
