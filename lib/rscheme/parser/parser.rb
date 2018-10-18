require 'rscheme/atom'
require 'rscheme/pair'
require 'rscheme/parser/lexer'
require 'rscheme/parser/parse_exception'

class Parser

  def initialize(sexp)
    @lexer = Lexer.new sexp
  end

  def parse
    parseBase
  end

  def parseBase
    type = @lexer.lex
    if type[0] == :open_parenthesis
      parseList
    elsif type[0] == :string
      Atom.ofString type[1]
    elsif type[0] == :symbol
      Atom.ofSymbol type[1]
    elsif type[0] == :number
      if type[1].include? '.'
        Atom.ofValue type[1].to_f
      else
        Atom.ofValue type[1].to_i
      end
    elsif type[0] == :quote
      parseQuote
    else
      raise ParseException, 'parse error:' + type[1]
    end
  end

  def parseList
    obj = Pair.ofPair Atom.ofNil, Atom.ofNil
    type = @lexer.lex
    loop do
      if type[0] == :close_parenthesis
        return obj
      else
        @lexer.push type
        obj2 = parseBase
        obj = ListUtil.append obj, Pair.ofPair(obj2, Atom.ofNil)
        type = @lexer.lex
      end
    end
  end

  def parseQuote
    # TODO
  end
end
