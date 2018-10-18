require 'rscheme/parser/lex_exception'

class Lexer

  def initialize(s)
    @s = s
    @it = s.each_char
    @buf = nil
  end

  def lex
    if @buf
      buf = @buf
      @buf = nil
      return buf
    end

    ch = ''
    loop do
      begin
        ch = @it.next
        if ch == ' ' || ch == '\t' || ch == '\n'
          next
        else
          break
        end
      rescue StopIteration => ex
        raise LexException, 'lexer error: no input'
      end
    end

    if ch == '('
      return lex_open_parenthesis ch
    elsif ch == ')'
      return lex_close_parenthesis ch
    elsif ch == '\''
      return lex_quote ch
    elsif ch == '"'
      return lex_string ch
    elsif ch == '-'
      return lex_minus ch
    elsif ch.match(/[0-9.]/)
      return lex_number ch
    else
      return lex_symbol ch
    end
  end

  def push(lex)
    @buf = lex
  end

  def lex_open_parenthesis(ch)
    [:open_parenthesis, '(']
  end

  def lex_close_parenthesis(ch)
    [:close_parenthesis, ')']
  end

  def lex_quote(ch)
    [:quote, "'"]
  end

  def lex_string(ch)
    str = ''
    loop do
      begin
        ch = @it.next
        if (ch == '"')
          return [:string, str]
        else
          str << ch
        end
      rescue StopIteration => ex
        raise LexException, 'lex error: end-of-line while scanning string literal'
      end
    end
  end

  def lex_minus(ch)
    c = @it.peek
    if c.match(/[0-9.]/)
      return lex_number(ch)
    else
      return [:symbol, '-']
    end
  end
  
  def lex_number(ch)
    str = ch
    if ch == '.'
      begin
        ch = @it.peek
        if ch.match(/[0-9]/)
          str << @it.next
        else
          return [:dot, '.']
        end
      rescue StopIteration => ex
        return [:dot, '.']
      end
    end

    loop do
      begin
        ch = @it.peek
        if ch.match(/[0-9.]/)
          str << @it.next
        else
          return [:number, str]
        end
      rescue StopIteration => ex
        return [:number, str]
      end
    end
  end

  def lex_symbol(ch)
    str = ch
    loop do
      begin
        ch = @it.peek
        if ch == ' ' || ch == '\t' || ch == '(' || ch == ')' || ch == '\'' || ch == '"' || ch == '\n'
          return [:symbol, str]
        else
          str << @it.next
        end
      rescue StopIteration => ex
        return [:symbol, str]
      end
    end
  end
end

