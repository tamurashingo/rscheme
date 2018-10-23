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

  def self.if(exp, env)
    if !Eval.eval(if_predicate(exp), env).nil?
      Eval.eval if_consequent(exp), env
    else
      Eval.eval if_alternative(exp), env
    end
  end

  def self.make_procedure(exp, env)
    parameters = lambda_parameters exp
    body = lambda_body exp
    ListUtil.list Atom.of_symbol("LAMBDA"), parameters, body, env
  end

  def self.sequence(exp, env)
    if ListUtil.last? exp
      Eval.eval ListUtil.first_list(exp), env
    else
      Eval.eval ListUtil.first_list(exp), env
      Apply.sequence ListUtil.rest_list(exp), env
    end
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

  def self.if_predicate(exp)
    # (if predicate
    #     ~~~~~~~~~
    #     consequence
    #     alternative)
    exp.cdr.car
  end

  def self.if_consequent(exp)
    # (if predicate
    #     consequence
    #     ~~~~~~~~~~~
    #     alternative)
    exp.cdr.cdr.car
  end

  def self.if_alternative(exp)
    # (if predicate
    #     consequence
    #     alternative)
    #     ~~~~~~~~~~~
    if !exp.cdr.cdr.cdr.nil?
      exp.cdr.cdr.cdr.car
    else
    # (if predicate
    #     consequence)
      Atom.of_nil
    end
  end

  def self.lambda_parameters(exp)
    # (lambda (x y) (+ x y))
    #         ~~~~~
    exp.cdr.car
  end

  def self.lambda_body(exp)
    # (lambda (x y) (+ x y))
    #               ~~~~~~~
    exp.cdr.cdr
  end

end
