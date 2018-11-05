require "rscheme/version"
require "rscheme/parser/parser"
require "rscheme/eval/initializer"
require "rscheme/eval/eval"

module Rscheme
  class Repl
    def initialize
      @env = Initializer.initialize_environment
    end

    def eval(s)
      parser = Parser.new s
      exp = parser.parse
      result = Eval.eval exp, @env
    end
  end
end
