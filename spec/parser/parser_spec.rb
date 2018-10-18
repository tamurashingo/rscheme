require 'pry'
require 'spec_helper'
require 'rscheme/parser/parser'
require 'rscheme/parser/parse_exception'

RSpec.describe 'Parser' do
  example 'string' do
    parser = Parser.new '"this is a pen"'
    obj = parser.parse

    expect(obj.nil?).to eq(false)
    expect(obj.type).to eq(:string)
    expect(obj.value).to eq("this is a pen")
  end

  example 'integer' do
    parser = Parser.new "100"
    obj = parser.parse

    expect(obj.nil?).to eq(false)
    expect(obj.type).to eq(:value)
    expect(obj.value).to eq(100)
  end

  example 'float' do
    parser = Parser.new "-3.14"
    obj = parser.parse

    expect(obj.nil?).to eq(false)
    expect(obj.type).to eq(:value)
    expect(obj.value).to eq(-3.14)
  end

  example 'symbol' do
    parser = Parser.new "variable"
    obj = parser.parse

    expect(obj.nil?).to eq(false)
    expect(obj.type).to eq(:symbol)
    expect(obj.value).to eq("VARIABLE")
  end

  example 'list: (+ X Y)' do
    parser = Parser.new "(+ X Y)"
    obj = parser.parse

    expect(obj.nil?).to eq(false)

    expect(obj.car.type).to eq(:symbol)
    expect(obj.car.value).to eq("+")

    expect(obj.cdr.car.type).to eq(:symbol)
    expect(obj.cdr.car.value).to eq("X")

    expect(obj.cdr.cdr.car.type).to eq(:symbol)
    expect(obj.cdr.cdr.car.value).to eq("Y")

    expect(obj.cdr.cdr.cdr.nil?).to eq(true)
  end

  example 'list: ((x 1) (y 2))' do
    parser = Parser.new "((x 1) (y 2))"
    obj = parser.parse

    expect(obj.nil?).to eq(false)

    expect(obj.car.type).to eq(:pair)

    # (x 1)
    expect(obj.car.car.type).to eq(:symbol)
    expect(obj.car.car.value).to eq("X")

    expect(obj.car.cdr.car.type).to eq(:value)
    expect(obj.car.cdr.car.value).to eq(1)

    expect(obj.car.cdr.cdr.nil?).to eq(true)

    # (y 1)
    expect(obj.cdr.car.car.type).to eq(:symbol)
    expect(obj.cdr.car.car.value).to eq("Y")

    expect(obj.cdr.car.cdr.car.type).to eq(:value)
    expect(obj.cdr.car.cdr.car.value).to eq(2)

    expect(obj.cdr.car.cdr.cdr.nil?).to eq(true)

    expect(obj.cdr.cdr.nil?).to eq(true)
  end

  example "quote: 'a => (QUOTE A)" do
    parser = Parser.new "'a"
    obj = parser.parse

    # (QUOTE A)
    expect(obj.type).to eq(:pair)

    expect(obj.car.type).to eq(:symbol)
    expect(obj.car.value).to eq("QUOTE")

    expect(obj.cdr.car.type).to eq(:symbol)
    expect(obj.cdr.car.value).to eq("A")

    expect(obj.cdr.cdr.nil?).to eq(true)
  end

  example "quote: '3.14 => (QUOTE 3.14)" do
    parser = Parser.new "'3.14"
    obj = parser.parse

    # (QUOTE 3.14)
    expect(obj.type).to eq(:pair)

    expect(obj.car.type).to eq(:symbol)
    expect(obj.car.value).to eq("QUOTE")

    expect(obj.cdr.car.type).to eq(:value)
    expect(obj.cdr.car.value).to eq(3.14)

    expect(obj.cdr.cdr.nil?).to eq(true)
  end

  example "quote: '(a b c) => (QUOTE (A B C))" do
    parser = Parser.new "'(a b c)"
    obj = parser.parse

    # (QUOTE )
    expect(obj.type).to eq(:pair)

    expect(obj.car.type).to eq(:symbol)
    expect(obj.car.value).to eq("QUOTE")

    expect(obj.cdr.car.type).to eq(:pair)

    expect(obj.cdr.car.car.type).to eq(:symbol)
    expect(obj.cdr.car.car.value).to eq("A")

    expect(obj.cdr.car.cdr.car.type).to eq(:symbol)
    expect(obj.cdr.car.cdr.car.value).to eq("B")

    expect(obj.cdr.car.cdr.cdr.car.type).to eq(:symbol)
    expect(obj.cdr.car.cdr.cdr.car.value).to eq("C")

    expect(obj.cdr.car.cdr.cdr.cdr.nil?).to eq(true)

    expect(obj.cdr.cdr.nil?).to eq(true)
  end

  context 'error case' do
    it "errors when read ')'" do
      parser = Parser.new ")"
      expect{ parser.parse }.to raise_error(ParseException)
    end
  end
end
