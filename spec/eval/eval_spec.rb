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
end
