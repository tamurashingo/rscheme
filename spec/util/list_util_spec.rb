require 'spec_helper'
require 'rscheme/atom'
require 'rscheme/pair'
require 'rscheme/util/list_util'

RSpec.describe 'ListUtil' do
  describe 'copy' do
    src = Pair.of_pair Atom.of_string("this"),
                       Pair.of_pair(Atom.of_string("is"),
                                    Pair.of_pair(Atom.of_string("a"),
                                                 Pair.of_pair(Atom.of_string("pen"), Atom.of_nil)))
    result = ListUtil.copy src
    it 'returns another instance' do
      expect(result).not_to be(src)
    end

    it 'copies' do
      expect(result.car.type).to eq(:string)
      expect(result.car.value).to eq("this")

      expect(result.cdr.car.type).to eq(:string)
      expect(result.cdr.car.value).to eq("is")

      expect(result.cdr.cdr.car.type).to eq(:string)
      expect(result.cdr.cdr.car.value).to eq("a")

      expect(result.cdr.cdr.cdr.car.type).to eq(:string)
      expect(result.cdr.cdr.cdr.car.value).to eq("pen")

      expect(result.cdr.cdr.cdr.cdr.nil?).to eq(true)
    end
  end

  describe 'append' do
    example 'nil nil -> nil' do
      result = ListUtil.append Atom.of_nil, Atom.of_nil
      expect(result.nil?).to eq(true)
    end

    context "'() '(a) -> '(a)" do
      l1 = Atom.of_nil
      l2 = Pair.of_pair Atom.of_symbol("a"), Atom.of_nil

      result = ListUtil.append l1, l2

      it "returns another instance" do
        expect(result.nil?).to eq(false)
        expect(result).not_to be(l2)
      end

      it "returns '(a)" do
        expect(result.car.type).to eq(:symbol)
        expect(result.car.value).to eq("A")
        expect(result.cdr.nil?).to eq(true)
      end
    end

    context "'(a) '(b c) -> '(a b c)" do
      l1 = Pair.of_pair Atom.of_symbol("a"), Atom.of_nil
      l2 = Pair.of_pair Atom.of_symbol("b"), Pair.of_pair(Atom.of_symbol("c"), Atom.of_nil)

      result = ListUtil.append l1, l2

      it "returns '(a b c)" do
        expect(result.car.type).to eq(:symbol)
        expect(result.car.value).to eq("A")

        expect(result.cdr.car.type).to eq(:symbol)
        expect(result.cdr.car.value).to eq("B")

        expect(result.cdr.cdr.car.type).to eq(:symbol)
        expect(result.cdr.cdr.car.value).to eq("C")

        expect(result.cdr.cdr.cdr.nil?).to eq(true)
      end

      it "does not change original list" do
        expect(l1.car.type).to eq(:symbol)
        expect(l1.car.value).to eq("A")
        expect(l1.cdr.nil?).to eq(true)

        expect(l2.car.type).to eq(:symbol)
        expect(l2.car.value).to eq("B")
        expect(l2.cdr.car.type).to eq(:symbol)
        expect(l2.cdr.car.value).to eq("C")
        expect(l2.cdr.cdr.nil?).to eq(true)
      end
    end
  end
end
