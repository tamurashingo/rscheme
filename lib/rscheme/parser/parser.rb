require 'rscheme/atom'
require 'rscheme/pair'
require 'rscheme/parser/lexer'
require 'rscheme/parser/parse_exception'
require 'rscheme/util/list_util'

module Rscheme
  class Parser

    def initialize(sexp)
      @lexer = Lexer.new sexp
    end

    def parse
      parse_base
    end

    def parse_base
      type = @lexer.lex
      if type[0] == :open_parenthesis
        parse_list
      elsif type[0] == :string
        Atom.of_string type[1]
      elsif type[0] == :symbol
        Atom.of_symbol type[1]
      elsif type[0] == :number
        if type[1].include? '.'
          Atom.of_value type[1].to_f
        else
          Atom.of_value type[1].to_i
        end
      elsif type[0] == :quote
        parse_quote
      else
        raise ParseException, 'parse error:' + type[1]
      end
    end

    def parse_list
      obj = Pair.of_pair Atom.of_nil, Atom.of_nil
      type = @lexer.lex
      loop do
        if type[0] == :close_parenthesis
          return obj
        else
          @lexer.push type
          obj2 = parse_base
          obj = ListUtil.append obj, Pair.of_pair(obj2, Atom.of_nil)
          type = @lexer.lex
        end
      end
    end

    def parse_quote
      Pair.of_pair Atom.of_symbol("QUOTE"), Pair.of_pair(parse_base, Atom.of_nil)
    end
  end
end

