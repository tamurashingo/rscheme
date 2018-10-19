require 'rscheme/atom'
require 'rscheme/eval/eval'

module Apply
  def self.assignment(exp, env)
    symbol = assignment_variable exp
    value = assignment_value exp, env

    env.set_variable symbol, value

    value
  end

  def self.assignment_variable(exp)
    # (set! x (+ x 1))
    #       ~
    exp.cdr.car.value
  end

  def self.assignment_value(exp, env)
    # (set! x (+ x 1))
    #         ~~~~~~~
    value = exp.cdr.cdr.car
    Eval.eval value, env
  end
end
