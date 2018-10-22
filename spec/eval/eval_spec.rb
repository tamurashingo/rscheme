require 'spec_helper'
require 'rscheme/rscheme_exception'
require 'rscheme/parser/parser'
require 'rscheme/eval/eval'

RSpec.describe 'Eval' do
  context 'self evaluating' do
    example 'number' do
      parser = Parser.new "10"
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(10)
    end

    example 'string' do
      parser = Parser.new '"this is a pen"'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:string)
      expect(result.value).to eq('this is a pen')
    end

    example 'nil' do
      parser = Parser.new '()'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.nil?).to eq(true)
    end
  end

  context 'variable' do
    example 'current environment' do
      global = Environment.create_global
      current = Environment.new global

      current.store "VALUE", Atom.of_value(1)

      parser = Parser.new 'value'
      exp = parser.parse

      result = Eval.eval exp, current

      expect(result.type).to eq(:value)
      expect(result.value).to eq(1)
    end

    example 'parent environment' do
      global = Environment.create_global
      current = Environment.new global

      global.store "VALUE2", Atom.of_string("this is a pen")

      parser = Parser.new "VALUE2"
      exp = parser.parse

      result = Eval.eval exp, current

      expect(result.type).to eq(:string)
      expect(result.value).to eq("this is a pen")
    end

    example 'not found' do
      global = Environment.create_global
      current = Environment.new global

      parser = Parser.new "no_value"
      exp = parser.parse

      expect{ Eval.eval exp, current }.to raise_error(RschemeException)
    end
  end

  context 'quoted' do
    example "'a" do
      parser = Parser.new "'a"
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:symbol)
      expect(result.value).to eq("A")
    end

    example "'-3.14" do
      parser = Parser.new "'-3.14"
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(-3.14)
    end

    example "'\"hello\"" do
      parser = Parser.new "'\"hello\""
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:string)
      expect(result.value).to eq("hello")
    end

    example "'(+ a 1)" do
      parser = Parser.new "'(+ a 1)"
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:pair)

      expect(result.car.type).to eq(:symbol)
      expect(result.car.value).to eq("+")

      expect(result.cdr.car.type).to eq(:symbol)
      expect(result.cdr.car.value).to eq("A")

      expect(result.cdr.cdr.car.type).to eq(:value)
      expect(result.cdr.cdr.car.value).to eq(1)

      expect(result.cdr.cdr.cdr.nil?).to eq(true)
    end
  end

  context 'set variable' do
    env = Environment.create_global
    example '(set! a 1)' do
      parser = Parser.new '(set! a 1)'
      exp = parser.parse

      result = Eval.eval exp, env

      expect(env.variables["A"].type).to eq(:value)
      expect(env.variables["A"].value).to eq(1)
    end

    example '(set! a "abc")' do
      parser = Parser.new '(set! a "abc")'
      exp = parser.parse

      result = Eval.eval exp, env

      expect(env.variables["A"].type).to eq(:string)
      expect(env.variables["A"].value).to eq("abc")
    end
  end

  context 'define' do
    env = Environment.create_global
    example '(define func (lambda (x) (+ x 1)))' do
      parser = Parser.new '(define func (lambda (x) (+ x 1)))'
      exp = parser.parse

      result = Eval.eval exp, env
      expect(env.variables['FUNC'].type).to eq(:pair)

      expect(env.variables['FUNC'].car.type).to eq(:symbol)
      expect(env.variables['FUNC'].car.value).to eq("LAMBDA")

      expect(env.variables['FUNC'].cdr.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.car.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.car.value).to eq("+")

      expect(env.variables['FUNC'].cdr.cdr.car.cdr.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.cdr.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.cdr.cdr.car.type).to eq(:value)
      expect(env.variables['FUNC'].cdr.cdr.car.cdr.cdr.car.value).to eq(1)

      expect(env.variables['FUNC'].cdr.cdr.car.cdr.cdr.cdr.nil?).to eq(true)
    end

    example '(define (func x) (+ x 2))' do
      parser = Parser.new '(define (func x) (+ x 2))'
      exp = parser.parse

      result = Eval.eval exp, env
      expect(env.variables['FUNC'].type).to eq(:pair)

      expect(env.variables['FUNC'].car.type).to eq(:symbol)
      expect(env.variables['FUNC'].car.value).to eq("LAMBDA")

      expect(env.variables['FUNC'].cdr.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.car.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.car.value).to eq("+")

      expect(env.variables['FUNC'].cdr.cdr.car.cdr.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.cdr.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.cdr.cdr.car.type).to eq(:value)
      expect(env.variables['FUNC'].cdr.cdr.car.cdr.cdr.car.value).to eq(2)

      expect(env.variables['FUNC'].cdr.cdr.car.cdr.cdr.cdr.nil?).to eq(true)
    end
  end

  context 'if' do
    example '(if 1 10 20) => 10' do
      parser = Parser.new '(if 1 10 20)'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(10)
    end

    example '(if () 10 20) => 20' do
      parser = Parser.new '(if () 10 20)'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(20)
    end

    example '(if () 10) => NIL' do
      parser = Parser.new '(if () 10)'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.nil?).to eq(true)
    end
  end

  context 'cond' do
    example '(cond (1 0) (else 1)) => 0' do
      parser = Parser.new '(cond (1 0) (else 1))'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(0)
    end

    example '(cond (() 0) (else 1)) => 1' do
      parser = Parser.new '(cond (() 0) (else 1))'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(1)
    end

    example '(cond (() 1) (else)) => nil' do
      parser = Parser.new '(cond (() 1) (else))'
      exp = parser.parse

      result = Eval.eval exp, Environment.create_global

      expect(result.nil?).to eq(true)
    end
  end
end
