require 'rscheme/atom'
require 'rscheme/eval/eval'

module Apply
  def self.assignment(exp, env)
    symbol = Assignment.variable exp
    value = Assignment.value exp, env

    env.set_variable symbol, value

    value
  end

  def self.definition(exp, env)
    symbol = Definition.variable exp
    value = Eval.eval (Definition.value exp), env

    env.set_variable symbol, value

    Atom.of_string "OK!"
  end

  def self.if(exp, env)
    if !Eval.eval(If.predicate(exp), env).nil?
      Eval.eval If.consequent(exp), env
    else
      Eval.eval If.alternative(exp), env
    end
  end

  def self.make_procedure(exp, env)
    parameters = Lambda.parameters exp
    body = Lambda.body exp
    ListUtil.list Atom.of_symbol("PROCEDURE"), parameters, body, env
  end

  def self.sequence(exp, env)
    if ListUtil.last? exp
      Eval.eval ListUtil.first_list(exp), env
    else
      Eval.eval ListUtil.first_list(exp), env
      sequence ListUtil.rest_list(exp), env
    end
  end

  def self.apply(procedure, arguments)
    if Apply.primitive_procedure? procedure
      Apply.apply_primitive_procedure procedure, arguments
    elsif Apply.compound_procedure? procedure
      sequence Apply.procedure_body(procedure), Apply.procedure_environment(procedure).extend_environment(Apply.procedure_parameters(procedure), arguments)
    end
  end
end


module Apply
  module Assignment
    def self.variable(exp)
      # (set! x (+ x 1))
      #       ~
      exp.cdr.car.value
    end

    def self.value(exp, env)
      # (set! x (+ x 1))
      #         ~~~~~~~
      value = exp.cdr.cdr.car
      Eval.eval value, env
    end
  end

  module Definition
    def self.variable(exp)
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

    def self.value(exp)
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

  module If
    def self.predicate(exp)
      # (if predicate
      #     ~~~~~~~~~
      #     consequence
      #     alternative)
      exp.cdr.car
    end

    def self.consequent(exp)
      # (if predicate
      #     consequence
      #     ~~~~~~~~~~~
      #     alternative)
      exp.cdr.cdr.car
    end

    def self.alternative(exp)
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
  end

  module Lambda
    def self.parameters(exp)
      # (lambda (x y) (+ x y))
      #         ~~~~~
      exp.cdr.car
    end

    def self.body(exp)
      # (lambda (x y) (+ x y))
      #               ~~~~~~~
      exp.cdr.cdr
    end
  end

  module Apply
    def self.primitive_procedure?(procedure)
      ListUtil.tagged_list procedure, 'PRIMITIVE'
    end

    def self.compound_procedure?(procedure)
      ListUtil.tagged_list(procedure, 'PROCEDURE')
    end

    def self.apply_primitive_procedure(procedure, arguments)
      cmd = procedure.cdr.car
      cmd.operate arguments
    end

    def self.procedure_parameters(procedure)
      # (PROCEDURE PARAMETERS BODY ENV)
      #            ~~~~~~~~~~
      procedure.cdr.car
    end

    def self.procedure_body(procedure)
      # (PROCEDURE PARAMETERS BODY ENV)
      #                       ~~~~
      procedure.cdr.cdr.car
    end

    def self.procedure_environment(procedure)
      # (PROCEDURE PARAMETERS BODY ENV)
      #                            ~~~
      procedure.cdr.cdr.cdr.car
    end
  end
end
