require 'spec_helper'
require 'rscheme/command/plus_command'
require 'rscheme/util/list_util'

RSpec.describe 'PlusCommand' do
  cmd = PlusCommand.new

  example '(+ 0 0) => 0' do
    a1 = Atom.of_value 0
    a2 = Atom.of_value 0

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(0)
  end

  example '(+ 5 2) => 7' do
    a1 = Atom.of_value 5
    a2 = Atom.of_value 2

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(7)
  end

  example '(+ 2 -3) => -1' do
    a1 = Atom.of_value 2
    a2 = Atom.of_value -3

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(-1)
  end

  example '(+ 2.5 3) => 5.5' do
    a1 = Atom.of_value 2.5
    a2 = Atom.of_value 3

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(5.5)
  end
end
