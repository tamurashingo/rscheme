module Rscheme
  class SchemeListIterator
    def initialize(list)
      @list = list
      @index = 0
    end

    def has_next?
      !@list.nil? && !@list.car.nil?
    end

    def next
      val = @list.car
      @list = @list.cdr
      val
    end
  end
end

