require 'spec_helper'
require 'rscheme/atom'
require 'rscheme/rscheme_exception'
require 'rscheme/pair'
require 'rscheme/command/cdr_command'

RSpec.describe 'CdrCommand' do
  cmd = Rscheme::CdrCommand.new

  context 'atom' do
    it 'raises error' do
      expect{ cmd.operate Rscheme::Atom.of_string('error') }.to raise_error{ Rscheme::RschemeException }
    end
  end

  context 'pair' do
    it 'gets cdr' do
      p = Rscheme::Pair.of_pair Rscheme::Atom.of_symbol('car'), Rscheme::Atom.of_symbol('cdr')
      expect((cmd.operate p).type).to eq(:symbol)
      expect((cmd.operate p).value).to eq('CDR')
    end
  end
end
