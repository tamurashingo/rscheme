require 'spec_helper'
require 'rscheme/lobj'
require 'rscheme/rscheme_exception'
require 'rscheme/parser/parser'
require 'rscheme/eval/eval'
require 'rscheme/eval/environment'
require 'rscheme/eval/initializer'

RSpec.describe 'Eval' do
  context 'self evaluating' do
    example 'number' do
      parser = Rscheme::Parser.new "10"
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(10)
    end

    example 'string' do
      parser = Rscheme::Parser.new '"this is a pen"'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:string)
      expect(result.value).to eq('this is a pen')
    end

    example 'nil' do
      parser = Rscheme::Parser.new '()'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.nil?).to eq(true)
    end
  end

  context 'variable' do
    example 'current environment' do
      global = Rscheme::Environment.create_global
      current = Rscheme::Environment.new global

      current.store "VALUE", Rscheme::Atom.of_value(1)

      parser = Rscheme::Parser.new 'value'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, current

      expect(result.type).to eq(:value)
      expect(result.value).to eq(1)
    end

    example 'parent environment' do
      global = Rscheme::Environment.create_global
      current = Rscheme::Environment.new global

      global.store "VALUE2", Rscheme::Atom.of_string("this is a pen")

      parser = Rscheme::Parser.new "VALUE2"
      exp = parser.parse

      result = Rscheme::Eval.eval exp, current

      expect(result.type).to eq(:string)
      expect(result.value).to eq("this is a pen")
    end

    example 'not found' do
      global = Rscheme::Environment.create_global
      current = Rscheme::Environment.new global

      parser = Rscheme::Parser.new "no_value"
      exp = parser.parse

      expect{ Rscheme::Eval.eval exp, current }.to raise_error(Rscheme::RschemeException)
    end
  end

  context 'quoted' do
    example "'a" do
      parser = Rscheme::Parser.new "'a"
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:symbol)
      expect(result.value).to eq("A")
    end

    example "'-3.14" do
      parser = Rscheme::Parser.new "'-3.14"
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(-3.14)
    end

    example "'\"hello\"" do
      parser = Rscheme::Parser.new "'\"hello\""
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:string)
      expect(result.value).to eq("hello")
    end

    example "'(+ a 1)" do
      parser = Rscheme::Parser.new "'(+ a 1)"
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

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
    env = Rscheme::Environment.create_global
    example '(set! a 1)' do
      parser = Rscheme::Parser.new '(set! a 1)'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, env

      expect(result.type).to eq(:value)
      expect(result.value).to eq(1)

      expect(env.variables["A"].type).to eq(:value)
      expect(env.variables["A"].value).to eq(1)
    end

    example '(set! a "abc")' do
      parser = Rscheme::Parser.new '(set! a "abc")'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, env

      expect(result.type).to eq(:string)
      expect(result.value).to eq("abc")

      expect(env.variables["A"].type).to eq(:string)
      expect(env.variables["A"].value).to eq("abc")
    end
  end

  context 'define' do
    env = Rscheme::Environment.create_global
    example '(define func (lambda (x) (+ x 1))) => (PROCEDURE (X) ((+ X 1)) (env)' do
      parser = Rscheme::Parser.new '(define func (lambda (x) (+ x 1)))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, env
      expect(env.variables['FUNC'].type).to eq(:pair)

      expect(env.variables['FUNC'].car.type).to eq(:symbol)
      expect(env.variables['FUNC'].car.value).to eq("PROCEDURE")

      expect(env.variables['FUNC'].cdr.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.car.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.car.car.value).to eq("+")

      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.cdr.car.type).to eq(:value)
      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.cdr.car.value).to eq(1)

      expect(env.variables['FUNC'].cdr.cdr.cdr.car.nil?).to eq(false)
    end

    example '(define (func x) (+ x 2))' do
      parser = Rscheme::Parser.new '(define (func x) (+ x 2))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, env
      expect(env.variables['FUNC'].type).to eq(:pair)

      expect(env.variables['FUNC'].car.type).to eq(:symbol)
      expect(env.variables['FUNC'].car.value).to eq("PROCEDURE")

      expect(env.variables['FUNC'].cdr.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.car.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.car.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.car.car.value).to eq("+")

      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.car.type).to eq(:symbol)
      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.car.value).to eq("X")

      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.cdr.car.type).to eq(:value)
      expect(env.variables['FUNC'].cdr.cdr.car.car.cdr.cdr.car.value).to eq(2)

      expect(env.variables['FUNC'].cdr.cdr.cdr.car.nil?).to eq(false)
    end
  end

  context 'if' do
    example '(if 1 10 20) => 10' do
      parser = Rscheme::Parser.new '(if 1 10 20)'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(10)
    end

    example '(if () 10 20) => 20' do
      parser = Rscheme::Parser.new '(if () 10 20)'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(20)
    end

    example '(if () 10) => NIL' do
      parser = Rscheme::Parser.new '(if () 10)'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.nil?).to eq(true)
    end
  end

  context 'cond' do
    example '(cond (1 0) (else 1)) => 0' do
      parser = Rscheme::Parser.new '(cond (1 0) (else 1))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(0)
    end

    example '(cond (() 0) (else 1)) => 1' do
      parser = Rscheme::Parser.new '(cond (() 0) (else 1))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.type).to eq(:value)
      expect(result.value).to eq(1)
    end

    example '(cond (() 1) (else)) => nil' do
      parser = Rscheme::Parser.new '(cond (() 1) (else))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.nil?).to eq(true)
    end
  end

  context 'lambda' do
    example '(lambda (x) (+ x 1)) => (lambda (x) ((+ x 1)) (..env..))' do
      parser = Rscheme::Parser.new '(lambda (x) (+ x 1))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.car.type).to eq(:symbol)
      expect(result.car.value).to eq("PROCEDURE")

      # args
      expect(result.cdr.car.type).to eq(:pair)
      expect(result.cdr.car.car.type).to eq(:symbol)
      expect(result.cdr.car.car.value).to eq("X")

      # body
      expect(result.cdr.cdr.car.type).to eq(:pair)
      expect(result.cdr.cdr.car.car.type).to eq(:pair)
      expect(result.cdr.cdr.car.car.car.type).to eq(:symbol)
      expect(result.cdr.cdr.car.car.car.value).to eq("+")
      expect(result.cdr.cdr.car.car.cdr.car.type).to eq(:symbol)
      expect(result.cdr.cdr.car.car.cdr.car.value).to eq("X")
      expect(result.cdr.cdr.car.car.cdr.cdr.car.type).to eq(:value)
      expect(result.cdr.cdr.car.car.cdr.cdr.car.value).to eq(1)

      # env
      expect(result.cdr.cdr.cdr.type).to eq(:pair)
    end

    example '(lambda (x y) (+ x 1) (+ y 2)) => (lambda (x y) ((+ x 1) (+ y 2)) (..env..))' do
      parser = Rscheme::Parser.new '(lambda (x y) (+ x 1) (+ y 2))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Environment.create_global

      expect(result.car.type).to eq(:symbol)
      expect(result.car.value).to eq("PROCEDURE")

      # args
      expect(result.cdr.car.type).to eq(:pair)
      expect(result.cdr.car.car.type).to eq(:symbol)
      expect(result.cdr.car.car.value).to eq("X")
      expect(result.cdr.car.cdr.car.value).to eq("Y")

      # body
      expect(result.cdr.cdr.car.type).to eq(:pair)

      # body 1
      # (lambda (x y) ((+ x 1) (+ y 2)) (..env..))
      #                ~~~~~~~
      expect(result.cdr.cdr.car.car.type).to eq(:pair)
      expect(result.cdr.cdr.car.car.car.type).to eq(:symbol)
      expect(result.cdr.cdr.car.car.car.value).to eq("+")
      expect(result.cdr.cdr.car.car.cdr.car.type).to eq(:symbol)
      expect(result.cdr.cdr.car.car.cdr.car.value).to eq("X")
      expect(result.cdr.cdr.car.car.cdr.cdr.car.type).to eq(:value)
      expect(result.cdr.cdr.car.car.cdr.cdr.car.value).to eq(1)

      # body 2
      # (lambda (x y) ((+ x 1) (+ y 2)) (..env..))
      #                        ~~~~~~~
      expect(result.cdr.cdr.car.cdr.car.type).to eq(:pair)
      expect(result.cdr.cdr.car.cdr.car.car.type).to eq(:symbol)
      expect(result.cdr.cdr.car.cdr.car.car.value).to eq("+")
      expect(result.cdr.cdr.car.cdr.car.cdr.car.type).to eq(:symbol)
      expect(result.cdr.cdr.car.cdr.car.cdr.car.value).to eq("Y")
      expect(result.cdr.cdr.car.cdr.car.cdr.cdr.car.type).to eq(:value)
      expect(result.cdr.cdr.car.cdr.car.cdr.cdr.car.value).to eq(2)

      # env
      expect(result.cdr.cdr.cdr.type).to eq(:pair)
    end
  end

  context 'begin' do
    example '(begin (set! x 1) (set! y 2)) => 2' do
      parser = Rscheme::Parser.new '(begin (set! x 1) (set! y 2))'
      exp = parser.parse
      env = Rscheme::Environment.create_global

      result = Rscheme::Eval.eval exp, env

      expect(result.type).to eq(:value)
      expect(result.value).to eq(2)

      expect(env.variables['X'].type).to eq(:value)
      expect(env.variables['X'].value).to eq(1)

      expect(env.variables['Y'].type).to eq(:value)
      expect(env.variables['Y'].value).to eq(2)
    end
  end

  context 'application' do
    example '(+ 1 2) => 3' do
      parser = Rscheme::Parser.new '(+ 1 2)'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Initializer.initialize_environment

      expect(result.type).to eq(:value)
      expect(result.value).to eq(3)
    end

    example '(+ 1 (+ 2 3)) => 6' do
      parser = Rscheme::Parser.new '(+ 1 (+ 2 3))'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, Rscheme::Initializer.initialize_environment

      expect(result.type).to eq(:value)
      expect(result.value).to eq(6)
    end

    example '(define (plus-one x) (+ x 1)) (plus-one 1) => 2' do
      env = Rscheme::Initializer.initialize_environment
      parser = Rscheme::Parser.new '(define (plus-one x) (+ x 1))'
      exp = parser.parse

      Rscheme::Eval.eval exp, env

      parser = Rscheme::Parser.new '(plus-one 1)'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, env

      expect(result.type).to eq(:value)
      expect(result.value).to eq(2)
    end

    example '(define (plus-two x) (plus-one (plus-one x))) (plus-two 3) => 5' do
      env = Rscheme::Initializer.initialize_environment
      parser = Rscheme::Parser.new '(define plus-one (lambda (x) (+ x 1)))'
      exp = parser.parse

      Rscheme::Eval.eval exp, env

      parser = Rscheme::Parser.new '(define (plus-two x) (plus-one (plus-one x)))'
      exp = parser.parse

      Rscheme::Eval.eval exp, env

      parser = Rscheme::Parser.new '(plus-two 3)'
      exp = parser.parse

      result = Rscheme::Eval.eval exp, env

      expect(result.type).to eq(:value)
      expect(result.value).to eq(5)
    end
  end

  example 'unknown expression' do
    expect{ Rscheme::Eval.eval Rscheme::LObj.new(:unknown, 'unknwon'), Rscheme::Initializer.initialize_environment }.to raise_error(Rscheme::RschemeException)
  end
end
