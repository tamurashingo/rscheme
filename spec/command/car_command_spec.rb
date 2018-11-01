require 'spec_helper'
require 'rscheme/atom'
require 'rscheme/rscheme_exception'
require 'rscheme/pair'
require 'rscheme/command/car_command'

RSpec.describe 'CarCommand' do
  cmd = Rscheme::CarCommand.new

  context 'atom' do
    it 'raises error' do
      expect{ cmd.operate Rscheme::Atom.of_string('error')}.to raise_error{ Rscheme::RschemeException }
    end
  end

  context 'pair' do
    it 'gets car' do
      p = Rscheme::Pair.of_pair Rscheme::Atom.of_symbol('car'), Rscheme::Atom.of_symbol('cdr')
      expect((cmd.operate p).type).to eq(:symbol)
      expect((cmd.operate p).value).to eq('CAR')
    end
  end
end
