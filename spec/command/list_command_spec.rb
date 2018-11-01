require 'spec_helper'
require 'rscheme/command/list_command'
require 'rscheme/util/list_util'

RSpec.describe 'ListCommand' do
  cmd = Rscheme::ListCommand.new

  example '(list nil)' do
    # (list nil) => (nil . nil)
    a1 = Rscheme::Atom.of_nil

    result = cmd.operate Rscheme::ListUtil.list(a1)

    expect(result.type).to eq(:pair)

    expect(result.car.nil?).to eq(true)
    expect(result.cdr.nil?).to eq(true)
  end

  example '(list atom)' do
    # (list atom) => (atom . nil)
    a1 = Rscheme::Atom.of_symbol 'atom'

    result = cmd.operate Rscheme::ListUtil.list(a1)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq('ATOM')

    expect(result.cdr.nil?).to eq(true)
  end

  example '(list atom atom)' do
    # (list atom atom) => (atom . (atom . nil))
    a1 = Rscheme::Atom.of_symbol 'atom1'
    a2 = Rscheme::Atom.of_string 'atom2'

    result = cmd.operate Rscheme::ListUtil.list(a1, a2)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq('ATOM1')

    expect(result.cdr.type).to eq(:pair)
    expect(result.cdr.car.type).to eq(:string)
    expect(result.cdr.car.value).to eq('atom2')

    expect(result.cdr.cdr.nil?).to eq(true)
  end

  example '(list atom atom atom)' do
    # (list aotm atom atom) => (atom . (atom . (atom . nil)))
    a1 = Rscheme::Atom.of_symbol 'atom1'
    a2 = Rscheme::Atom.of_string 'atom2'
    a3 = Rscheme::Atom.of_value 3

    result = cmd.operate Rscheme::ListUtil.list(a1, a2, a3)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:symbol)
    expect(result.car.value).to eq('ATOM1')

    expect(result.cdr.type).to eq(:pair)
    expect(result.cdr.car.type).to eq(:string)
    expect(result.cdr.car.value).to eq('atom2')

    expect(result.cdr.cdr.type).to eq(:pair)
    expect(result.cdr.cdr.car.type).to eq(:value)
    expect(result.cdr.cdr.car.value).to eq(3)

    expect(result.cdr.cdr.cdr.nil?).to eq(true)
  end

  example "(list '(atom . atom) atom)" do
    # (list '(atom . atom) atom) => ((atom . atom) . (atom . nil))
    a1 = Rscheme::Pair.of_pair Rscheme::Atom.of_symbol('atom1'), Rscheme::Atom.of_string('atom2')
    a2 = Rscheme::Atom.of_value 3

    result = cmd.operate Rscheme::ListUtil.list(a1, a2)

    expect(result.type).to eq(:pair)

    expect(result.car.type).to eq(:pair)
    expect(result.car.car.type).to eq(:symbol)
    expect(result.car.car.value).to eq('ATOM1')
    expect(result.car.cdr.type).to eq(:string)
    expect(result.car.cdr.value).to eq('atom2')

    expect(result.cdr.type).to eq(:pair)
    expect(result.cdr.car.type).to eq(:value)
    expect(result.cdr.car.value).to eq(3)
    expect(result.cdr.cdr.nil?).to eq(true)
  end
end
