require 'pry'

require 'spec_helper'
require 'rscheme/parser/lexer'

RSpec.describe 'Lexer' do
  it "returns [:opens_parenthesis, '(']" do
    lexer = Rscheme::Lexer.new "("
    expect(lexer.lex).to eq [:open_parenthesis, '(']
  end

  it "returns [:close_parenthesis, ')]" do
    lexer = Rscheme::Lexer.new ")"
    expect(lexer.lex).to eq [:close_parenthesis, ')']
  end

  it "returns [:quote, '\'']" do
    lexer = Rscheme::Lexer.new "'(3.14)"
    expect(lexer.lex).to eq [:quote, '\'']
  end

  it "returns [:symbol, '-']" do
    lexer = Rscheme::Lexer.new "- 10 20"
    expect(lexer.lex).to eq [:symbol, '-']
  end

  it "returns [:number, '-10']" do
    lexer = Rscheme::Lexer.new "-10 20"
    expect(lexer.lex).to eq [:number, '-10']
  end

  it "returns [:number, '.5']" do
    lexer = Rscheme::Lexer.new ".5 10"
    expect(lexer.lex).to eq [:number, '.5']
  end

  it "returns [:number, '-.5']" do
    lexer = Rscheme::Lexer.new "-.5 10"
    expect(lexer.lex).to eq [:number, '-.5']
  end

  it "returns [:number, '3.14']" do
    lexer = Rscheme::Lexer.new "3.14"
    expect(lexer.lex).to eq [:number, '3.14']
  end

  it "returns [:dot, '.']" do
    lexer = Rscheme::Lexer.new ".a"
    expect(lexer.lex).to eq [:dot, '.']

    lexer = Rscheme::Lexer.new "."
    expect(lexer.lex).to eq [:dot, '.']
  end

  it "returns [:symbol, 'abc']" do
    lexer = Rscheme::Lexer.new "abc def"
    expect(lexer.lex).to eq [:symbol, 'abc']
  end

  it "returns [:symbol, 'abc']" do
    lexer = Rscheme::Lexer.new "abc"
    expect(lexer.lex).to eq [:symbol, 'abc']
  end

  it "returns [:symbol, 'def']" do
    lexer = Rscheme::Lexer.new "abc def"
    lexer.push [:symbol, 'def']
    expect(lexer.lex).to eq [:symbol, 'def']
  end

  context 'error pattern' do
    it 'raises error when no input' do
      lexer = Rscheme::Lexer.new ""
      expect{ lexer.lex }.to raise_error(Rscheme::LexException)

      lexer = Rscheme::Lexer.new "   "
      expect{ lexer.lex }.to raise_error(Rscheme::LexException)
    end

    it 'raises error when scanning string' do
      lexer = Rscheme::Lexer.new '"abc'
      expect{ lexer.lex }.to raise_error(Rscheme::LexException)
    end
  end
end
