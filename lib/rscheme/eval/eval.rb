require 'rscheme/util/list_util'

module Eval
  
  def self.eval(exp, env)
    if self_evaluating? exp
      exp
    elsif variable? exp
      env.lookup exp.value
    elsif quoted? exp
      exp.cdr.car
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

  def self.application(exp)
    exp.type == :pair
  end
end
