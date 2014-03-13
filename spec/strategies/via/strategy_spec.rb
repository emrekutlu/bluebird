require 'spec_helper'

describe Bluebird::Strategies::Via::Strategy do

  let!(:strategy) { Bluebird::Strategies::Via::Strategy }

  describe '#username_exists?' do
    context 'When username is nil' do
      it 'returns false' do
        expect(strategy.send(:username_exists?, nil)).to be_false
      end
    end
    context "When username is ''" do
      it 'returns false' do
        expect(strategy.send(:username_exists?, '')).to be_false
      end
    end
    context "When username is ' '" do
      it 'returns false' do
        expect(strategy.send(:username_exists?, ' ')).to be_false
      end
    end
    context 'When username is iekutlu' do
      it 'returns false' do
        expect(strategy.send(:username_exists?, 'iekutlu')).to be_true
      end
    end
  end

  describe '#text' do
    it 'adds a space to the begining' do
      config = Bluebird::Strategies::Via::Config
      config.username = 'iekutlu'
      expect(strategy.send(:text, config).start_with?(' ')).to be_true
    end
    it "adds 'prefix' to the begining" do
      config = Bluebird::Strategies::Via::Config
      config.username = 'iekutlu'
      config.prefix   = 'via'
      expect(strategy.send(:text, config).start_with?(' via')).to be_true
    end
    it 'adds username to the end' do
      config = Bluebird::Strategies::Via::Config
      config.username = 'iekutlu'
      expect(strategy.send(:text, config).end_with?('iekutlu')).to be_true
    end
  end
end
