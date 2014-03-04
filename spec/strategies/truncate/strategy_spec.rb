require 'spec_helper'

describe Bluebird::Strategies::Truncate::Strategy do

  let!(:strategy) { Bluebird::Strategies::Truncate::Strategy }

  describe '#run?' do
    it 'returns true if tweet is longer than max' do
      tweet = Bluebird::Tweet.new('Lorem ipsum')
      expect(strategy.send(:run?, tweet, 10)).to be_true
    end
    it 'returns false if tweet is shorter than max' do
      tweet = Bluebird::Tweet.new('Lorem ipsum')
      expect(strategy.send(:run?, tweet, 15)).to be_false
    end
  end

  describe '#truncate' do

    context 'When tweet is shorter than max' do
      it 'does not modify the tweet' do
        tweet = Bluebird::Tweet.new('Lorem #ipsum @dolor')
        strategy.send(:truncate, tweet, 20)
        expect(tweet.status).to eq 'Lorem #ipsum @dolor'
      end
    end

    context "When tweet's length is equal to max" do
      it 'does not modify the tweet' do
        tweet = Bluebird::Tweet.new('Lorem #ipsum @dolor ')
        strategy.send(:truncate, tweet, 20)
        expect(tweet.status).to eq 'Lorem #ipsum @dolor '
      end
    end

    context 'When tweet is longer than max' do
      it 'truncates the text partial which can handle all the truncation' do
        Bluebird::Config.truncate.omission = '...'
        tweet = Bluebird::Tweet.new('Lorem ipsum #dolor sit #amet')
        strategy.send(:truncate, tweet, 20)
        expect(tweet.status).to eq '... #dolor sit #amet'
      end
      it 'does nothing if there is no text partial' do
        tweet = Bluebird::Tweet.new('#Lorem @ipsum dolor.com #amet')
        strategy.send(:truncate, tweet, 20)
        expect(tweet.status).to eq '#Lorem @ipsum dolor.com #amet'
      end
      it 'truncates all text partials' do
        tweet = Bluebird::Tweet.new('#Lorem ipsum dolor.com and #amet')
        strategy.send(:truncate, tweet, 20)
        expect(tweet.status).to eq '#Lorem dolor.com #amet'
      end
    end

  end

  describe '#truncate_partials' do

    before(:all) { Bluebird::Config.truncate.omission = '...' }

    it 'truncates the text partials' do
      tweet = Bluebird::Tweet.new('Lorem ipsum @dolor sit')
      strategy.send(:truncate_partials, tweet, 9)
      expect(tweet.status).to eq 'Lor... @dolor'
    end
    it 'truncates the text partials' do
      tweet = Bluebird::Tweet.new('Lorem ipsum @dolor sit #amet')
      strategy.send(:truncate_partials, tweet, 9)
      expect(tweet.status).to eq 'Lor... @dolor #amet'
    end
  end

  describe '#truncate_partial' do
    context 'When partial can handle whole truncation' do

      it 'truncates the partial' do
        partial = Bluebird::Partial.new('Lorem', :text)
        strategy.send(:truncate_partial, partial, 3)
        expect(partial.content).to eq 'Lo'
      end

      context 'and with trailing whitespace' do
        context 'and without a trailing partial' do
          it 'truncates the partial' do
            partial = Bluebird::Partial.new('Lorem  ', :text)
            strategy.send(:truncate_partial, partial, 3)
            expect(partial.content).to eq 'Lore'
          end
        end
        context 'and with a trailing partial' do
          it 'truncates the partial and keeps the trailing space' do
            tweet = Bluebird::Tweet.new('Lorem @ipsum')
            partial = tweet.partials[0]
            strategy.send(:truncate_partial, partial, 3)
            expect(partial.content).to eq 'Lo '
          end
        end
      end

      context 'and partial is between two entities' do
        it 'truncates the partial and adds a space' do
          tweet = Bluebird::Tweet.new('#Lorem ipsum @dolor')
          partial = tweet.partials[1]
          strategy.send(:truncate_partial, partial, 6)
          expect(partial.content).to eq ' '
        end
      end

    end

    context 'When partial cannot handle whole truncation' do
      context 'and partial is a reply preventer' do
        it 'truncates the partial and adds a dot to prevent replying' do
          tweet = Bluebird::Tweet.new('Lorem @ipsum')
          partial = tweet.partials[0]
          strategy.send(:truncate_partial, partial, 6)
          expect(partial.content).to eq '.'
        end
      end
      context 'and partial is between two entities' do
        it 'truncates the partial and adds a space' do
          tweet = Bluebird::Tweet.new('#Lorem ipsum @dolor')
          partial = tweet.partials[1]
          strategy.send(:truncate_partial, partial, 8)
          expect(partial.content).to eq ' '
        end
      end
      context 'and partial can be deleted' do
        it "deletes the partial's content" do
          tweet = Bluebird::Tweet.new('#Lorem ipsum @dolor sit')
          partial = tweet.partials[3]
          strategy.send(:truncate_partial, partial, 5)
          expect(partial.content).to eq ''
        end
      end
    end
  end

  describe '#add_omission' do
    context 'When omission is present' do

      before(:all) { Bluebird::Config.truncate.omission = '...' }

      context 'and partial can handle the omission' do

        it 'adds the omission' do
          partial = Bluebird::Partial.new('Lorem ipsum', :text)
          strategy.send(:add_omission, partial)
          expect(partial.content).to eq 'Lorem ip...'
        end

        context 'with trailing entity' do
          it 'adds the omission before the whitespace' do
            tweet = Bluebird::Tweet.new('Lorem ipsum http://www.example.com')
            partial = tweet.partials[0]
            strategy.send(:add_omission, partial)
            expect(partial.content).to eq 'Lorem ip... '
          end
        end
      end

      context 'and partial cannot handle omission' do
        it 'does not add omission' do
          partial = Bluebird::Partial.new('Lor', :text)
          strategy.send(:add_omission, partial)
          expect(partial.content).to eq 'Lor'
        end
      end
    end
    context 'When omission is nil' do
      it 'does not add omission' do
        Bluebird::Config.truncate.omission = nil
        partial = Bluebird::Partial.new('Lorem ipsum', :text)
        strategy.send(:add_omission, partial)
        expect(partial.content).to eq 'Lorem ipsum'
      end
    end
    context 'When omission is false' do
      it 'does not add omission' do
        Bluebird::Config.truncate.omission = false
        partial = Bluebird::Partial.new('Lorem ipsum', :text)
        strategy.send(:add_omission, partial)
        expect(partial.content).to eq 'Lorem ipsum'
      end
    end
  end

end
