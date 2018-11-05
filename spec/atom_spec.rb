require 'spec_helper'
require 'rscheme/atom'

RSpec.describe 'Atom' do
  describe 'to_s' do
    example 'string' do
      atom = Rscheme::Atom.of_string 'hello'
      expect(atom.to_s).to eq('"hello"')
    end

    example 'symbol' do
      atom = Rscheme::Atom.of_symbol 'hello'
      expect(atom.to_s).to eq('HELLO')
    end

    example 'value' do
      atom = Rscheme::Atom.of_value 3.14
      expect(atom.to_s).to eq('3.14')
    end

    example 'nil' do
      atom = Rscheme::Atom.of_nil
      expect(atom.to_s).to eq('NIL')
    end
  end
end
