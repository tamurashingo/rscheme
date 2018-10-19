require 'spec_helper'

require 'rscheme/rscheme_exception'
require 'rscheme/eval/environment'

RSpec.describe 'Environment' do
  context 'lookup' do
    env1 = Environment.new nil
    env2 = Environment.new env1
    env3 = Environment.new env2

    env1.store "VALUE1", 1
    env2.store "VALUE2", 2
    env3.store "VALUE3", 3

    example '自分自身の値を取得できること' do
      expect(env3.lookup("VALUE3")).to eq(3)
    end

    example '親の値を取得できること' do
      expect(env3.lookup("VALUE2")).to eq(2)
    end

    example '親の親の値を取得できること' do
      expect(env3.lookup("VALUE1")).to eq(1)
    end

    example '値を取得できない場合は例外が発生すること' do
      expect{ env3.lookup("VALUE0") }.to raise_error(RschemeException)
    end
  end
  
end

