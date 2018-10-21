require 'rscheme/atom'
require 'rscheme/eval/eval'

module Apply
  def self.assignment(exp, env)
    symbol = assignment_variable exp
    value = assignment_value exp, env

    env.set_variable symbol, value

    value
  end

  def self.definition(exp, env)
    symbol = definition_variable exp
    value = definition_value exp

    env.set_variable symbol, value

    Atom.of_string "OK!"
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

  def self.definition_variable(exp)
    if exp.cdr.car.type != :pair
      # (define func (lambda (x) (+ x 1)))
      #         ~~~~
      exp.cdr.car.value
    else
      # (define (func x) (+ x 1))
      #          ~~~~
      exp.cdr.car.car.value
    end
  end

  def self.definition_value(exp)
    if exp.cdr.car.type != :pair
      # (define func (lambda (x) (+ x 1)))
      #              ~~~~~~~~~~~~~~~~~~~~
      exp.cdr.cdr.car
    else
      # (define (func x y) (+ x y))
      #               ~~~  ~~~~~~~
      make_lambda exp.cdr.car.cdr, exp.cdr.cdr
    end
  end

  def self.make_lambda(parameters, body)
    Pair.of_pair Atom.of_symbol("LAMBDA"),
                 Pair.of_pair(parameters, body)
  end

end
