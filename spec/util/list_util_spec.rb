require 'spec_helper'
require 'rscheme/atom'
require 'rscheme/pair'
require 'rscheme/util/list_util'

RSpec.describe 'ListUtil' do
  describe 'copy' do
    src = Pair.ofPair Atom.ofString("this"),
                      Pair.ofPair(Atom.ofString("is"),
                                  Pair.ofPair(Atom.ofString("a"),
                                              Pair.ofPair(Atom.ofString("pen"), Atom.ofNil)))
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

      expect(result.cdr.cdr.cdr.cdr.isNil).to eq(true)
    end
  end

  describe 'append' do
    example 'nil nil -> nil' do
      result = ListUtil.append Atom.ofNil, Atom.ofNil
      expect(result.isNil).to eq(true)
    end

    context "'() '(a) -> '(a)" do
      l1 = Atom.ofNil
      l2 = Pair.ofPair Atom.ofSymbol("a"), Atom.ofNil

      result = ListUtil.append l1, l2

      it "returns another instance" do
        expect(result.isNil).to eq(false)
        expect(result).not_to be(l2)
      end

      it "returns '(a)" do
        expect(result.car.type).to eq(:symbol)
        expect(result.car.value).to eq("A")
        expect(result.cdr.isNil).to eq(true)
      end
    end

    context "'(a) '(b c) -> '(a b c)" do
      l1 = Pair.ofPair Atom.ofSymbol("a"), Atom.ofNil
      l2 = Pair.ofPair Atom.ofSymbol("b"), Pair.ofPair(Atom.ofSymbol("c"), Atom.ofNil)

      result = ListUtil.append l1, l2

      it "returns '(a b c)" do
        expect(result.car.type).to eq(:symbol)
        expect(result.car.value).to eq("A")

        expect(result.cdr.car.type).to eq(:symbol)
        expect(result.cdr.car.value).to eq("B")

        expect(result.cdr.cdr.car.type).to eq(:symbol)
        expect(result.cdr.cdr.car.value).to eq("C")

        expect(result.cdr.cdr.cdr.isNil).to eq(true)
      end

      it "does not change original list" do
        expect(l1.car.type).to eq(:symbol)
        expect(l1.car.value).to eq("A")
        expect(l1.cdr.isNil).to eq(true)

        expect(l2.car.type).to eq(:symbol)
        expect(l2.car.value).to eq("B")
        expect(l2.cdr.car.type).to eq(:symbol)
        expect(l2.cdr.car.value).to eq("C")
        expect(l2.cdr.cdr.isNil).to eq(true)
      end
    end
  end
end
