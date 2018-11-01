require 'spec_helper'
require 'rscheme/atom'
require 'rscheme/pair'
require 'rscheme/command/cons_command'
require 'rscheme/util/list_util'

RSpec.describe 'ConsCommand' do
  cmd = ConsCommand.new

  example 'cons atom atom' do
    # (cons atom1 "atom2") => (atom1 . "atom2")
    a1 = Atom.of_symbol 'atom1'
    a2 = Atom.of_string 'atom2'

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq('ATOM1')
    expect(result.cdr.type).to eq(:string)
    expect(result.cdr.value).to eq('atom2')
  end

  example 'cons atom pair' do
    # (cons atom1 (cons "atom2" 3)) => (atom1 . ("atom2" . 3))
    a1 = Atom.of_symbol 'atom1'
    a2 = Pair.of_pair Atom.of_string('atom2'), Atom.of_value(3)

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq('ATOM1')

    expect(result.cdr.type).to eq(:pair)
    expect(result.cdr.car.type).to eq(:string)
    expect(result.cdr.car.value).to eq('atom2')
    expect(result.cdr.cdr.type).to eq(:value)
    expect(result.cdr.cdr.value).to eq(3)
  end

  example 'cons pair atom' do
    # (cons (cons atom1 "atom2") 3) => ((atom1 . "atom2") . 3)
    a1 = Pair.of_pair Atom.of_symbol('atom1'), Atom.of_string('atom2')
    a2 = Atom.of_value 3

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:pair)
    expect(result.car.car.type).to eq(:symbol)
    expect(result.car.car.value).to eq('ATOM1')
    expect(result.car.cdr.type).to eq(:string)
    expect(result.car.cdr.value).to eq('atom2')

    expect(result.cdr.type).to eq(:value)
    expect(result.cdr.value).to eq(3)
  end

  example 'cons pair pair' do
    # (cons (cons atom1 "atom2") (cons 3 4)) => ((atom1 . "atom2") . (3 . 4))
    a1 = Pair.of_pair Atom.of_symbol('atom1'), Atom.of_string("atom2")
    a2 = Pair.of_pair Atom.of_value(3), Atom.of_value(4)

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:pair)
    expect(result.car.car.type).to eq(:symbol)
    expect(result.car.car.value).to eq('ATOM1')
    expect(result.car.cdr.type).to eq(:string)
    expect(result.car.cdr.value).to eq('atom2')

    expect(result.cdr.type).to eq(:pair)
    expect(result.cdr.car.type).to eq(:value)
    expect(result.cdr.car.value).to eq(3)
    expect(result.cdr.cdr.type).to eq(:value)
    expect(result.cdr.cdr.value).to eq(4)
  end
end
