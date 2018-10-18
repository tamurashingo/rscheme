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
      return lexOpenParenthesis ch
    elsif ch == ')'
      return lexCloseParenthesis ch
    elsif ch == '\''
      return lexQuote ch
    elsif ch == '"'
      return lexString ch
    elsif ch == '-'
      return lexMinus ch
    elsif ch.match(/[0-9.]/)
      return lexNumber ch
    else
      return lexSymbol ch
    end
  end

  def push(lex)
    @buf = lex
  end

  def lexOpenParenthesis(ch)
    [:open_parenthesis, '(']
  end

  def lexCloseParenthesis(ch)
    [:close_parenthesis, ')']
  end

  def lexQuote(ch)
    [:quote, "'"]
  end

  def lexString(ch)
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

  def lexMinus(ch)
    c = @it.peek
    if c.match(/[0-9.]/)
      return lexNumber(ch)
    else
      return [:symbol, '-']
    end
  end
  
  def lexNumber(ch)
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

  def lexSymbol(ch)
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

