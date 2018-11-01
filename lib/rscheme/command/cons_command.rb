require 'rscheme/pair'

module Rscheme
  class ConsCommand
    def operate(exp)
      Pair.of_pair exp.car, exp.cdr.car
    end
  end
end
