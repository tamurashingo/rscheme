require 'rscheme/atom'

class MinusCommand
  def operate(exp)
    Atom.of_value(exp.car.value - exp.cdr.car.value)
  end
end
