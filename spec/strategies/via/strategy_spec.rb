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
    it "adds 'prefix' to the begining" do
      config = Bluebird::Strategies::Via::Config
      config.username = 'iekutlu'
      config.prefix   = 'via'
      expect(strategy.send(:text, config).start_with?('via')).to be_true
    end
    it 'adds username to the end' do
      config = Bluebird::Strategies::Via::Config
      config.username = 'iekutlu'
      expect(strategy.send(:text, config).end_with?('@iekutlu')).to be_true
    end
  end

  describe '#add_separator?' do
    context 'When tweet is not empty' do
      it 'returns true' do
        tweet = Bluebird::Tweet.new('Lorem ipsum')
        expect(strategy.send(:add_separator?, tweet)).to be_true
      end
    end
    context 'When tweet is empty' do
      it 'returns false' do
        tweet = Bluebird::Tweet.new('')
        expect(strategy.send(:add_separator?, tweet)).to be_false
      end
    end
  end

  describe '#add_separator_partial' do
    it "adds a new text partial whose content is ' '" do
      tweet = Bluebird::Tweet.new('Lorem #ipsum')
      strategy.send(:add_separator_partial, tweet)
      last = tweet.partials.last
      expect(last.text?).to be_true
      expect(last.content).to eq ' '
    end
  end

  describe '#add_space_to_last_partial' do
    context 'When text partial has trailing space' do
      it 'does not add trailing space' do
        tweet = Bluebird::Tweet.new('Lorem ipsum ')
        strategy.send(:add_space_to_last_partial, tweet)
        expect(tweet.status).to eq 'Lorem ipsum '
      end
    end
    context 'When text partial does not have trailing space' do
      it 'adds trailing space' do
        tweet = Bluebird::Tweet.new('Lorem ipsum')
        strategy.send(:add_space_to_last_partial, tweet)
        expect(tweet.status).to eq 'Lorem ipsum '
      end
    end
  end
end
