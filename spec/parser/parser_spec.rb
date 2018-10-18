require 'spec_helper'
require 'rscheme/parser/parser'

RSpec.describe 'Parser' do
  example 'string' do
    parser = Parser.new '"this is a pen"'
    obj = parser.parse

    expect(obj.isNil).to eq(false)
    expect(obj.type).to eq(:string)
    expect(obj.value).to eq("this is a pen")
  end

  example 'integer' do
    parser = Parser.new "100"
    obj = parser.parse

    expect(obj.isNil).to eq(false)
    expect(obj.type).to eq(:value)
    expect(obj.value).to eq(100)
  end

  example 'float' do
    parser = Parser.new "-3.14"
    obj = parser.parse

    expect(obj.isNil).to eq(false)
    expect(obj.type).to eq(:value)
    expect(obj.value).to eq(-3.14)
  end
end
