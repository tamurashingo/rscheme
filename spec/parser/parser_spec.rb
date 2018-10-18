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
end
