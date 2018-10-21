require 'rscheme/atom'
require 'rscheme/pair'
require 'rscheme/rscheme_exception'
require 'rscheme/util/list_util'


module CondConverter
  def self.cond_to_if(exp)
    # (COND ((= x 1) 1)
    #       ((= x 2) 2)
    #       (else    3))
    expand_clauses cond_clauses(exp)
  end

  def self.cond_clauses(clause)
    # (COND ((= x 1) 1)
    #       ((= x 2) 2)
    #       (else    3))
    # =>
    # (((= x 1) 1) ((= x 2) 2) (else 3))
    clause.cdr
  end

  def self.cond_predicate(clause)
    # ((= X 1) 1)
    #  ~~~~~~~
    # (else 3)
    #  ~~~~
    clause.car
  end

  def self.cond_actions(clause)
    # ((= X 1) 1)
    #          ~
    # (else (begin (display "this is a pen") (newline)))
    #       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    clause.cdr
  end

  def self.cond_else_clause?(clause)
    result = cond_predicate clause
    result.type == :symbol && result.value == "ELSE"
  end

  def self.last_exp?(seq)
    seq.cdr.nil?
  end

  def self.first_exp(seq)
    seq.car
  end

  def self.sequence_to_exp(seq)
    if seq.nil?
      seq
    elsif last_exp? seq
      first_exp seq
    else
      Pair.of_pair Atom.of_symbol("BEGIN"), seq
    end
  end

  def self.make_if(predicate, consequence, alternative)
    # (if predicate
    #     consequence
    #     alternative)
    ListUtil.list Atom.of_symbol("IF"), predicate, consequence, alternative
  end

  def self.expand_clauses(clauses)
    # (((= x 1) 1) ((= x 2) 2) (else 3))
    if clauses.nil?
      Atom.of_nil
    else
      first = ListUtil.first_list clauses # ((= X 1) 1)
      rest = ListUtil.rest_list clauses   # (((= X 2) 2) (ELSE 3))
      if cond_else_clause? first
        if rest.nil?
          sequence_to_exp cond_actions(first)
        else
          raise RschemeException, 'cond parse error: else must be last'
        end
      else
        make_if cond_predicate(first), sequence_to_exp(cond_actions(first)), expand_clauses(rest)
      end
    end
  end
end
