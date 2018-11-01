require 'spec_helper'
require 'rscheme/atom'
require 'rscheme/rscheme_exception'
require 'rscheme/pair'
require 'rscheme/command/cdr_command'

RSpec.describe 'CdrCommand' do
  cmd = CdrCommand.new

  context 'atom' do
    it 'raises error' do
      expect{ cmd.operate Atom.of_string('error') }.to raise_error{ RschemeException }
    end
  end

  context 'pair' do
    it 'gets cdr' do
      p = Pair.of_pair Atom.of_symbol('car'), Atom.of_symbol('cdr')
      expect((cmd.operate p).type).to eq(:symbol)
      expect((cmd.operate p).value).to eq('CDR')
    end
  end
end
