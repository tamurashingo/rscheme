require 'rscheme/atom'

module Rscheme
  class PlusCommand
    def operate(exp)
      Atom.of_value exp.car.value + exp.cdr.car.value
    end
  end
end
