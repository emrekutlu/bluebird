require 'spec_helper'

describe Bluebird::Strategies::Strip::Strategy do

  before(:all) do
    Bluebird.configure do |config|
      config.max_length = 20
      config.characters_reserved_per_media = 5
    end
  end

  let!(:strategy) { Bluebird::Strategies::Strip::Strategy }
  let(:config) { Bluebird::Config }

  context 'When tweet is shorter than max' do
    context 'and without leading whitespace' do
      context 'and without trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum'
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum'
          end
        end
      end
      context 'and with trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum     ')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum     '
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem      ', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem      '
          end
        end
      end
    end
    context 'and with leading whitespace' do
      context 'and without trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('     Lorem ipsum')
            strategy.run(tweet, config)
            expect(tweet.status).to eq '     Lorem ipsum'
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('     Lorem', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq '     Lorem'
          end
        end
      end
      context 'and with trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('   Lorem ipsum   ')
            strategy.run(tweet, config)
            expect(tweet.status).to eq '   Lorem ipsum   '
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('   Lorem    ', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq '   Lorem    '
          end
        end
      end
    end
  end

  context 'When tweet is longer than max' do
    context 'and without leading whitespace' do
      context 'and without trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum dolor sit amet')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum dolor sit amet', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
          end
        end
      end
      context 'and with trailing whitespace' do
        context 'and without media' do
          it 'strips the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum dolor sit amet     ')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
          end
        end
        context 'and with media' do
          it 'strips the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum sit    ', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum sit'
          end
        end
      end
    end
    context 'and with leading whitespace' do
      context 'and without trailing whitespace' do
        context 'and without media' do
          it 'strips the tweet' do
            tweet = Bluebird::Tweet.new('     Lorem ipsum dolor sit amet')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
          end
        end
        context 'and without media' do
          it 'strips the tweet' do
            tweet = Bluebird::Tweet.new('     Lorem ipsum', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum'
          end
        end
      end
      context 'and with trailing whitespace' do
        context 'and without media' do
          it 'strips the tweet' do
            tweet = Bluebird::Tweet.new('     Lorem ipsum dolor sit amet     ')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
          end
        end
        context 'and without media' do
          it 'strips the tweet' do
            tweet = Bluebird::Tweet.new('   Lorem ipsum   ', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum'
          end
        end
      end
    end
  end

  context "When tweet's length is equal to max" do
    context 'and without leading whitespace' do
      context 'and without trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum dolor si')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dolor si'
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum dol', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dol'
          end
        end
      end
      context 'and with trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum dolor   ')
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum dolor   '
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('Lorem ipsum    ', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq 'Lorem ipsum    '
          end
        end
      end
    end
    context 'and with leading whitespace' do
      context 'and without trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('   Lorem ipsum dolor')
            strategy.run(tweet, config)
            expect(tweet.status).to eq '   Lorem ipsum dolor'
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('   Lorem ipsumd', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq '   Lorem ipsumd'
          end
        end
      end
      context 'and with trailing whitespace' do
        context 'and without media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('  Lorem ipsum dolo  ')
            strategy.run(tweet, config)
            expect(tweet.status).to eq '  Lorem ipsum dolo  '
          end
        end
        context 'and with media' do
          it 'does not modify the tweet' do
            tweet = Bluebird::Tweet.new('  Loremi dolo  ', media: true)
            strategy.run(tweet, config)
            expect(tweet.status).to eq '  Loremi dolo  '
          end
        end
      end
    end
  end

end
