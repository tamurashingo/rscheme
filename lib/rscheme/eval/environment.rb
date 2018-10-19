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
end
