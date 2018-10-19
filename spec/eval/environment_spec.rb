require 'spec_helper'

require 'rscheme/rscheme_exception'
require 'rscheme/eval/environment'

RSpec.describe 'Environment' do
  context 'set_variable' do
    env1 = Environment.new nil
    env2 = Environment.new env1
    env3 = Environment.new env2

    env1.store :value1, 1
    env2.store :value2, 2
    env3.store :value3, 3

    example '前提の確認' do
      expect(env3.variables[:value3]).to eq(3)
      expect(env2.variables[:value2]).to eq(2)
      expect(env1.variables[:value1]).to eq(1)
    end

    example '新しい変数は呼び出されたEnvironmentに設定されること' do
      env3.set_variable :new_value, 4
      expect(env3.variables[:new_value]).to eq(4)
      expect(env2.variables[:new_value]).to eq(nil)
      expect(env1.variables[:new_value]).to eq(nil)
    end

    example '`すでにある変数を上書きすること' do
      env3.set_variable :value3, "value3"
      expect(env3.variables[:value3]).to eq("value3")
    end

    example '親の変数を上書きすること' do
      env3.set_variable :value2, "value2"

      expect(env3.variables[:value2]).to eq(nil)
      expect(env2.variables[:value2]).to eq("value2")
      expect(env1.variables[:value2]).to eq(nil)
    end

    example '親の親の変数を上書きすること' do
      env3.set_variable :value1, "value1"

      expect(env3.variables[:value1]).to eq(nil)
      expect(env2.variables[:value1]).to eq(nil)
      expect(env1.variables[:value1]).to eq("value1")
    end
  end

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

