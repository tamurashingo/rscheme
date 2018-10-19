require 'spec_helper'
require 'rscheme/rscheme_exception'
require 'rscheme/parser/parser'
require 'rscheme/eval/eval'

RSpec.describe 'Eval' do
  context 'self evaluating' do
    example 'number' do
      parser = Parser.new "10"
      exp = parser.parse

      result = Eval.eval exp, nil

      expect(result.type).to eq(:value)
      expect(result.value).to eq(10)
    end

    example 'string' do
      parser = Parser.new '"this is a pen"'
      exp = parser.parse

      result = Eval.eval exp, nil

      expect(result.type).to eq(:string)
      expect(result.value).to eq('this is a pen')
    end

    example 'nil' do
      parser = Parser.new '()'
      exp = parser.parse

      result = Eval.eval exp, nil

      expect(result.nil?).to eq(true)
    end
  end
end
