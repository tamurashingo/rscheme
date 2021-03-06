require 'spec_helper'
require 'rscheme/util/list_util'
require 'rscheme/util/scheme_list_iterator'

RSpec.describe 'SchemeListIterator' do
  example '("this" "is" "a" "pen")' do
    list = Rscheme::ListUtil.list Rscheme::Atom.of_string("this"), Rscheme::Atom.of_string("is"), Rscheme::Atom.of_string("a"), Rscheme::Atom.of_string("pen")

    iterator = Rscheme::SchemeListIterator.new list

    expect(iterator.has_next?).to eq(true)

    value = iterator.next
    expect(value.type).to eq(:string)
    expect(value.value).to eq("this")

    expect(iterator.has_next?).to eq(true)
    value = iterator.next
    expect(value.type).to eq(:string)
    expect(value.value).to eq("is")

    expect(iterator.has_next?).to eq(true)
    value = iterator.next
    expect(value.type).to eq(:string)
    expect(value.value).to eq("a")

    expect(iterator.has_next?).to eq(true)
    value = iterator.next
    expect(value.type).to eq(:string)
    expect(value.value).to eq("pen")

    expect(iterator.has_next?).to eq(false)
  end

  example '()' do
    list = Rscheme::ListUtil.list

    iterator = Rscheme::SchemeListIterator.new list

    expect(iterator.has_next?).to eq(false)
  end
end
