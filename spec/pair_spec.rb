require 'spec_helper'
require 'rscheme/atom'
require 'rscheme/pair'

RSpec.describe 'Pair' do
  describe 'to_s' do
    example '(1 . 2)' do
      pair = Rscheme::Pair.of_pair Rscheme::Atom.of_value(1), Rscheme::Atom.of_value(2)
      expect(pair.to_s).to eq('(1 . 2)')
    end

    example '(1 2 3)' do
      pair = Rscheme::Pair.of_pair Rscheme::Atom.of_value(1),
                                   Rscheme::Pair.of_pair(Rscheme::Atom.of_value(2),
                                                         Rscheme::Pair.of_pair(Rscheme::Atom.of_value(3), Rscheme::Atom.of_nil))
      expect(pair.to_s).to eq('(1 2 3)')
    end
  end
end
