require 'spec_helper'
require 'rscheme/command/minus_command'
require 'rscheme/util/list_util'

RSpec.describe 'MinusCommand' do
  cmd = MinusCommand.new

  example '(- 0 0) => 0' do
    a1 = Atom.of_value 0
    a2 = Atom.of_value 0

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(0)
  end

  example '(- 5 2) => 3' do
    a1 = Atom.of_value 5
    a2 = Atom.of_value 2

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(3)
  end

  example '(- 2 3) => -1' do
    a1 = Atom.of_value 2
    a2 = Atom.of_value 3

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(-1)
  end

  example '(- 2.5 3) => -0.5' do
    a1 = Atom.of_value 2.5
    a2 = Atom.of_value 3

    result = cmd.operate ListUtil.list(a1, a2)

    expect(result.type).to eq(:value)
    expect(result.value).to eq(-0.5)
  end
end
