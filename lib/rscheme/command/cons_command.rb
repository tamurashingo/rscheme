require 'rscheme/pair'

class ConsCommand
  def operate(exp)
    Pair.of_pair exp.car, exp.cdr.car
  end
end
