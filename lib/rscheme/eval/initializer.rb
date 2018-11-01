require 'rscheme/atom'
require 'rscheme/command/car_command'
require 'rscheme/command/cdr_command'
require 'rscheme/command/cons_command'
require 'rscheme/command/list_command'
require 'rscheme/command/minus_command'
require 'rscheme/command/plus_command'
require 'rscheme/eval/environment'

module Initializer
  def self.initialize_environment()
    env = Environment.create_global
    env.set_variable "+", ListUtil.list(Atom.of_symbol("PRIMITIVE"), PlusCommand.new)
    env.set_variable "-", ListUtil.list(Atom.of_symbol("PRIMITIVE"), MinusCommand.new)
    env.set_variable "CAR", ListUtil.list(Atom.of_symbol("PRIMITIVE"), CarCommand.new)
    env.set_variable "CDR", ListUtil.list(Atom.of_symbol("PRIMITIVE"), CdrCommand.new)
    env.set_variable "CONS", ListUtil.list(Atom.of_symbol("PRIMITIVE"), ConsCommand.new)
    env.set_variable "LIST", ListUtil.list(Atom.of_symbol("PRIMITIVE"), ListCommand.new)
    env
  end
end
