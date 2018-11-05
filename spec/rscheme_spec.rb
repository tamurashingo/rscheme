require 'spec_helper'
require 'rscheme'

RSpec.describe 'Rscheme' do
  it "has a version number" do
    expect(Rscheme::VERSION).not_to be nil
  end

  example '1 => 1' do
    repl = Rscheme::Repl.new

    result = repl.eval('1')
    expect(result.type).to eq(:value)
    expect(result.value).to eq(1)
  end

  example '"string" => "string"' do
    repl = Rscheme::Repl.new

    result = repl.eval('"string"')
    expect(result.type).to eq(:string)
    expect(result.value).to eq('string')
  end

  example '(set! x "symbol") x => "symbol"' do
    repl = Rscheme::Repl.new
    repl.eval('(set! x "symbol")')

    result = repl.eval('x')
    expect(result.type).to eq(:string)
    expect(result.value).to eq('symbol')
  end

  example '(+ 1 2) => 3' do
    repl = Rscheme::Repl.new

    result = repl.eval('(+ 1 2)')
    expect(result.type).to eq(:value)
    expect(result.value).to eq(3)
  end

  example '(define (plus3 x) (+ x 3)) (plus3 2) => 5' do
    repl = Rscheme::Repl.new
    repl.eval('(define (plus3 x) (+ x 3))')

    result = repl.eval('(plus3 2)')
    expect(result.type).to eq(:value)
    expect(result.value).to eq(5)
  end
end
