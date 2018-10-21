require 'spec_helper'
require 'rscheme/rscheme_exception'
require 'rscheme/eval/cond_converter'

RSpec.describe 'CondConveter' do
  example '(cond ((> x 1) x) ((= x 0) 0) (else (- x 0)))' do
    source = '(cond ((> x 1) x) ((= x 0) 0) (else (- x 0)))'
    parser = Parser.new source
    exp = parser.parse

    result = CondConverter.cond_to_if exp

    # (IF (> x 1) X (IF (= X 0) 0 (- X 0)))

    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq("IF")

    expect(result.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.car.car.value).to eq(">")
    expect(result.cdr.car.cdr.car.type).to eq(:symbol)
    expect(result.cdr.car.cdr.car.value).to eq("X")
    expect(result.cdr.car.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.car.cdr.cdr.car.value).to eq(1)

    expect(result.cdr.cdr.car.type).to eq(:symbol)
    expect(result.cdr.cdr.car.value).to eq("X")

    expect(result.cdr.cdr.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.car.value).to eq("IF")
    
    expect(result.cdr.cdr.cdr.car.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.car.car.value).to eq("=")
    expect(result.cdr.cdr.cdr.car.cdr.car.cdr.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.car.cdr.car.value).to eq("X")
    expect(result.cdr.cdr.cdr.car.cdr.car.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.cdr.cdr.car.cdr.car.cdr.cdr.car.value).to eq(0)

    # (car (cdr (cdr (car (cdr (cdr (cdr '(IF (> x 1) X (IF (= X 0) 0 (- X 0))))))))))
    # => 0
    expect(result.cdr.cdr.cdr.car.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.car.value).to eq(0)

    # (car (cdr (cdr (cdr (car (cdr (cdr (cdr '(IF (> x 1) X (IF (= X 0) 0 (- X 0)))))))))))
    # => (- X 0)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.car.value).to eq("-")
    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.car.value).to eq("X")
    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.cdr.cdr.car.value).to eq(0)
  end

  example '(cond (true x) (false y) (else 0))' do
    source = '(cond (true x) (false y) (else 0))'
    parser = Parser.new source
    exp = parser.parse

    result = CondConverter.cond_to_if exp

    # (IF TRUE X (IF FALSE Y 0))

    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq("IF")

    expect(result.cdr.car.type).to eq(:symbol)
    expect(result.cdr.car.value).to eq("TRUE")

    expect(result.cdr.cdr.car.type).to eq(:symbol)
    expect(result.cdr.cdr.car.value).to eq("X")

    expect(result.cdr.cdr.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.car.value).to eq("IF")

    expect(result.cdr.cdr.cdr.car.cdr.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.car.value).to eq("FALSE")
    
    expect(result.cdr.cdr.cdr.car.cdr.cdr.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.car.value).to eq("Y")

    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.cdr.car.value).to eq(0)
end

  example '(cond (true x) (else 0) (false y)) => RschemeException' do
    source = '(cond (true x) (else 0) (false y))'
    parser = Parser.new source
    exp = parser.parse

    expect { CondConverter.cond_to_if exp }.to raise_error(RschemeException)
  end
end
