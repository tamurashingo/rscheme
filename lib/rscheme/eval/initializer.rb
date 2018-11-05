require 'rscheme/atom'
require 'rscheme/command/car_command'
require 'rscheme/command/cdr_command'
require 'rscheme/command/cons_command'
require 'rscheme/command/list_command'
require 'rscheme/command/minus_command'
require 'rscheme/command/plus_command'
require 'rscheme/eval/environment'

module Rscheme
  module Initializer
    def self.initialize_environment()
      env = Environment.create_global
      env.set_variable "+", ListUtil.list(Atom.of_symbol("PRIMITIVE"), Atom.of_other(PlusCommand.new))
      env.set_variable "-", ListUtil.list(Atom.of_symbol("PRIMITIVE"), Atom.of_other(MinusCommand.new))
      env.set_variable "CAR", ListUtil.list(Atom.of_symbol("PRIMITIVE"), Atom.of_other(CarCommand.new))
      env.set_variable "CDR", ListUtil.list(Atom.of_symbol("PRIMITIVE"), Atom.of_other(CdrCommand.new))
      env.set_variable "CONS", ListUtil.list(Atom.of_symbol("PRIMITIVE"), Atom.of_other(ConsCommand.new))
      env.set_variable "LIST", ListUtil.list(Atom.of_symbol("PRIMITIVE"), Atom.of_other(ListCommand.new))
      env
    end
  end
end
