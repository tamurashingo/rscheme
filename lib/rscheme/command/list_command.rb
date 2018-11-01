require 'rscheme/atom'
require 'rscheme/pair'
require 'rscheme/util/list_util'
require 'rscheme/util/scheme_list_iterator'

class ListCommand
  def operate(exp)
    it = SchemeListIterator.new exp
    lst = Pair.of_pair Atom.of_nil, Atom.of_nil
    while it.has_next?
      lst = ListUtil.append lst, Pair.of_pair(it.next, Atom.of_nil)
    end
    lst
  end
end
