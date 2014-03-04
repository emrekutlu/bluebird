require 'spec_helper'

describe Bluebird::Strategies::Squeeze::Strategy do

  before(:all) do
    Bluebird.configure do |config|
      config.max_length = 20
      config.characters_reserved_per_media = 5
    end
  end

  let!(:strategy) { Bluebird::Strategies::Squeeze::Strategy }
  let!(:config) { Bluebird::Config }

  context 'When tweet is shorter than max' do
    context 'and without leading whitespaces' do
      context 'and without trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum dolor')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor'
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
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem   ipsum dolor')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem   ipsum dolor'
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem   ipsum ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem   ipsum '
            end
          end
        end
      end
      context 'and with trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum dolor  ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor  '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum   ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum   '
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem   ipsum do  ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem   ipsum do  '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem    do  ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem    do  '
            end
          end
        end
      end
    end
    context 'and with leading whitespaces' do
      context 'and without trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('    Lorem ipsum do')
              strategy.run(tweet, config)
              expect(tweet.status).to eq '    Lorem ipsum do'
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('    Lorem do', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq '    Lorem do'
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('  Lorem   ipsum do')
              strategy.run(tweet, config)
              expect(tweet.status).to eq '  Lorem   ipsum do'
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('  Lorem    do', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq '  Lorem    do'
            end
          end
        end
      end
      context 'and with trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('  Lorem ipsum do  ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq '  Lorem ipsum do  '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('  Lorem do  ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq '  Lorem do  '
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('  Lorem   ipsum do  ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq '  Lorem   ipsum do  '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('  Lorem    do  ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq '  Lorem    do  '
            end
          end
        end
      end
    end
  end

  context 'When tweet is longer than max' do
    context 'and without leading whitespaces' do
      context 'and without trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum dolor sit amet')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum dolor', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor'
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'squeezes the middle whitespaces' do
              tweet = Bluebird::Tweet.new('Lorem ipsum    dolor sit amet')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
            end
          end
          context 'and with media' do
            it 'squeezes the middle whitespaces' do
              tweet = Bluebird::Tweet.new('Lorem ipsum    dolor sit amet', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor sit amet'
            end
          end
        end
      end
      context 'and with trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'squeezes the trailing whitespaces' do
              tweet = Bluebird::Tweet.new('Lorem ipsum dolor sit amet   ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor sit amet '
            end
          end
          context 'and with media' do
            it 'squeezes the trailing whitespaces' do
              tweet = Bluebird::Tweet.new('Lorem ipsum dolor sit amet   ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor sit amet '
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'squeezes the trailing & middle whitespaces' do
              tweet = Bluebird::Tweet.new('Lorem ipsum   dolor sit amet   ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor sit amet '
            end
          end
          context 'and with media' do
            it 'squeezes the trailing & middle whitespaces' do
              tweet = Bluebird::Tweet.new('Lorem ipsum   dolor sit amet   ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor sit amet '
            end
          end
        end
      end
    end
    context 'and with leading whitespaces' do
      context 'and without trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'squeezes the leading whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum dolor sit amet')
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet'
            end
          end
          context 'and with media' do
            it 'squeezes the leading whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum dolor sit amet', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet'
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'squeezes the leading & middle whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem   ipsum dolor sit amet')
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet'
            end
          end
          context 'and with media' do
            it 'squeezes the leading & middle whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem   ipsum dolor sit amet', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet'
            end
          end
        end
      end
      context 'and with trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'squeezes the leading & trailing whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum dolor sit amet   ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet '
            end
          end
          context 'and with media' do
            it 'squeezes the leading & trailing whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum dolor sit amet   ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet '
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'squeezes the leading & middle & trailing whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum    dolor sit amet   ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet '
            end
          end
          context 'and with media' do
            it 'squeezes the leading & middle & trailing whitespaces' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum    dolor sit amet   ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq ' Lorem ipsum dolor sit amet '
            end
          end
        end
      end
    end
  end

  context "When tweet's length is equal to max" do
    context 'and without leading whitespaces' do
      context 'and without trailing whitespaces' do
        context 'and without middle whitespaces' do
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
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum    dolor')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum    dolor'
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem     dolor', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem     dolor'
            end
          end
        end
      end
      context 'and with trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum dolor   ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum dolor   '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Loremx dolor   ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Loremx dolor   '
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem ipsum   dol   ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem ipsum   dol   '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('Lorem    dol   ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq 'Lorem    dol   '
            end
          end
        end
      end
    end
    context 'and with leading whitespaces' do
      context 'and without trailing whitespaces' do
        context 'and without middle whitespaces' do
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
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum   dol')
              strategy.run(tweet, config)
              expect(tweet.status).to eq '   Lorem ipsum   dol'
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('   Lorem    dol', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq '   Lorem    dol'
            end
          end
        end
      end
      context 'and with trailing whitespaces' do
        context 'and without middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('   Lorem ipsum dol  ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq '   Lorem ipsum dol  '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('   Loremi dol  ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq '   Loremi dol  '
            end
          end
        end
        context 'and with middle whitespaces' do
          context 'and without media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('   Lorem ips   dol  ')
              strategy.run(tweet, config)
              expect(tweet.status).to eq '   Lorem ips   dol  '
            end
          end
          context 'and with media' do
            it 'does not modify the tweet' do
              tweet = Bluebird::Tweet.new('   Lore   dol  ', media: true)
              strategy.run(tweet, config)
              expect(tweet.status).to eq '   Lore   dol  '
            end
          end
        end
      end
    end
  end

end
