require 'rscheme/eval/apply'
require 'rscheme/util/list_util'

module Rscheme
  module Eval
  
    def self.eval(exp, env)
      if self_evaluating? exp
        exp
      elsif variable? exp
        env.lookup exp.value
      elsif quoted? exp
        exp.cdr.car
      elsif assignment? exp
        Apply.assignment exp, env
      elsif definition? exp
        Apply.definition exp, env
      elsif if? exp
        Apply.if exp, env
      elsif lambda? exp
        Apply.make_procedure exp, env
      elsif begin? exp
        Apply.sequence exp.cdr, env
      elsif cond? exp
        Eval.eval CondConverter.cond_to_if(exp), env
      elsif application? exp
        Apply.apply Eval.eval(operator(exp), env),
                    list_of_values(operands(exp), env)
      else
        raise RschemeException, "unknown expression:#{exp.type}:#{exp.value}"
      end
    end

    def self.self_evaluating?(exp)
      exp.type == :value || exp.type == :string || exp.nil?
    end

    def self.variable?(exp)
      exp.type == :symbol
    end

    def self.quoted?(exp)
      ListUtil.tagged_list exp, "QUOTE"
    end

    def self.assignment?(exp)
      ListUtil.tagged_list exp, "SET!"
    end

    def self.definition?(exp)
      ListUtil.tagged_list exp, "DEFINE"
    end

    def self.if?(exp)
      ListUtil.tagged_list exp, "IF"
    end

    def self.lambda?(exp)
      ListUtil.tagged_list exp, "LAMBDA"
    end

    def self.begin?(exp)
      ListUtil.tagged_list exp, "BEGIN"
    end

    def self.cond?(exp)
      ListUtil.tagged_list exp, "COND"
    end

    def self.application?(exp)
      exp.type == :pair
    end

    def self.operator(exp)
      exp.car
    end

    def self.operands(exp)
      exp.cdr
    end

    def self.first_operand(operands)
      operands.car
    end

    def self.rest_operands(operands)
      operands.cdr
    end

    def self.list_of_values(exp, env)
      if exp.nil?
        Atom.of_nil
      else
        Pair.of_pair Eval.eval(first_operand(exp), env),
                     list_of_values(rest_operands(exp), env)
      end
    end
  end
end

