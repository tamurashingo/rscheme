require 'spec_helper'
require 'rscheme/rscheme_exception'
require 'rscheme/eval/cond_converter'

RSpec.describe 'CondConveter' do
  example '(cond ((> x 1) x) ((= x 0) 0) (else (- x 0))) => (IF (> x 1) X (IF (= X 0) 0 (- X 0)))' do
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

  example '(cond (true x) (false y) (else 0)) => (IF TRUE X (IF FALSE Y 0))' do
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

  example '(cond (1 2)) => (if 1 2)' do
    source = '(cond (1 2))'
    parser = Parser.new source
    exp = parser.parse

    result = CondConverter.cond_to_if exp

    # (IF 1 2)
    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq("IF")

    expect(result.cdr.car.type).to eq(:value)
    expect(result.cdr.car.value).to eq(1)

    expect(result.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.cdr.car.value).to eq(2)
  end

  example '(cond (1 (display "ok") (newline)) (else (display "ng") (newline))) => (if 1 (begin (display "ok") (newline)) (begin (display "ng") (newline)))' do
    source = '(cond (1 (display "ok") (newline)) (else (display "ng") (newline)))'
    parser = Parser.new source
    exp = parser.parse

    result = CondConverter.cond_to_if exp

    # (if 1 (begin (display "ok") (newline)) (begin (display "ng") (newline)))
    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq("IF")

    expect(result.cdr.car.type).to eq(:value)
    expect(result.cdr.car.value).to eq(1)

    expect(result.cdr.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.car.car.value).to eq("BEGIN")

    expect(result.cdr.cdr.car.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.car.cdr.car.car.value).to eq("DISPLAY")

    expect(result.cdr.cdr.car.cdr.car.cdr.car.type).to eq(:string)
    expect(result.cdr.cdr.car.cdr.car.cdr.car.value).to eq("ok")

    expect(result.cdr.cdr.car.cdr.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.car.cdr.cdr.car.car.value).to eq("NEWLINE")

    expect(result.cdr.cdr.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.car.value).to eq("BEGIN")

    expect(result.cdr.cdr.cdr.car.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.car.car.value).to eq("DISPLAY")

    expect(result.cdr.cdr.cdr.car.cdr.car.cdr.car.type).to eq(:string)
    expect(result.cdr.cdr.cdr.car.cdr.car.cdr.car.value).to eq("ng")

    expect(result.cdr.cdr.cdr.car.cdr.cdr.car.car.type).to eq(:symbol)
    expect(result.cdr.cdr.cdr.car.cdr.cdr.car.car.value).to eq("NEWLINE")
  end

  example '(cond (() 1)) => (if () 1)' do
    source = '(cond (() 1)) => (if () 1)'
    parser = Parser.new source
    exp = parser.parse

    result = CondConverter.cond_to_if exp

    # (if () 1)
    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq("IF")

    expect(result.cdr.car.type).to eq(:pair)
    expect(result.cdr.car.nil?).to eq(true)

    expect(result.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.cdr.car.value).to eq(1)
  end
end
