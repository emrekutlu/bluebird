#encoding: utf-8

require 'spec_helper'

describe Bluebird::Tweet do

  describe '#initialize' do
    it 'sets original_status' do
      tweet = Bluebird::Tweet.new('Lorem ipsum')
      expect(tweet.original_status).to eq 'Lorem ipsum'
    end

    it 'sets partials' do
      tweet = Bluebird::Tweet.new('Lorem ipsum')
      expect(tweet.partials).to be_kind_of Array
    end

    context 'When media options is present' do
      it 'sets the media' do
        tweet = Bluebird::Tweet.new('Lorem ipsum', media: true)
        expect(tweet.media).to be_true
      end
    end

    context 'When media options is missing' do
      it 'does not set the media' do
        tweet = Bluebird::Tweet.new('Lorem ipsum')
        expect(tweet.media).to be_nil
      end
    end
  end

  describe '#status' do
    it 'returns the status of the tweet' do
      tweet = Bluebird::Tweet.new('Lorem #ipsum @dolor $sit amet')
      expect(tweet.status).to eq 'Lorem #ipsum @dolor $sit amet'
    end
  end

  describe '#length' do
    context 'When with media' do
      it 'returns the length' do
        tweet = Bluebird::Tweet.new('Lorem #ipsum @dolor $sit amet')
        expect(tweet.length).to be 29
      end
    end
    context 'When without media' do
      it 'returns the length' do
        Bluebird::Config.characters_reserved_per_media = 5
        tweet = Bluebird::Tweet.new('Lorem #ipsum @dolor $sit amet', media: true)
        expect(tweet.length).to be 34
      end
    end
    context 'When has unicode characters' do
      it 'returns the length' do
        tweet = Bluebird::Tweet.new('İşçğdööüqizpqiıı')
        expect(tweet.length).to be 16
      end
    end
  end

  describe '#extract_partials' do

    context 'When status is empty' do
      it 'does not add any partial' do
        tweet = Bluebird::Tweet.new('')
        expect(tweet.partials.length).to eq 0
      end
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('Lorem ipsum')
      expect(tweet.partials.length).to eq 1

      partial = tweet.partials[0]
      expect(partial.content).to eq 'Lorem ipsum'
      expect(partial.text?).to be_true
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('Lorem #ipsum')
      expect(tweet.partials.length).to eq 2

      partial = tweet.partials[0]
      expect(partial.content).to eq 'Lorem '
      expect(partial.text?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq '#ipsum'
      expect(partial.hashtag?).to be_true
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('#Lorem #ipsum')
      expect(tweet.partials.length).to eq 3

      partial = tweet.partials[0]
      expect(partial.content).to eq '#Lorem'
      expect(partial.hashtag?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq ' '
      expect(partial.text?).to be_true

      partial = tweet.partials[2]
      expect(partial.content).to eq '#ipsum'
      expect(partial.hashtag?).to be_true
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('#Lorem ipsum @dolor')
      expect(tweet.partials.length).to eq 3

      partial = tweet.partials[0]
      expect(partial.content).to eq '#Lorem'
      expect(partial.hashtag?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq ' ipsum '
      expect(partial.text?).to be_true

      partial = tweet.partials[2]
      expect(partial.content).to eq '@dolor'
      expect(partial.mention?).to be_true
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new(' #Lorem ipsum @dolor ')
      expect(tweet.partials.length).to eq 5

      partial = tweet.partials[0]
      expect(partial.content).to eq ' '
      expect(partial.text?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq '#Lorem'
      expect(partial.hashtag?).to be_true

      partial = tweet.partials[2]
      expect(partial.content).to eq ' ipsum '
      expect(partial.text?).to be_true

      partial = tweet.partials[3]
      expect(partial.content).to eq '@dolor'
      expect(partial.mention?).to be_true

      partial = tweet.partials[4]
      expect(partial.content).to eq ' '
      expect(partial.text?).to be_true
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('http://example.com example.com.')
      expect(tweet.partials.length).to eq 4

      partial = tweet.partials[0]
      expect(partial.content).to eq 'http://example.com'
      expect(partial.url?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq ' '
      expect(partial.text?).to be_true

      partial = tweet.partials[2]
      expect(partial.content).to eq 'example.com'
      expect(partial.url?).to be_true

      partial = tweet.partials[3]
      expect(partial.content).to eq '.'
      expect(partial.text?).to be_true
    end

    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('#abc.#def')
      expect(tweet.partials.length).to eq 3

      partial = tweet.partials[0]
      expect(partial.content).to eq '#abc'
      expect(partial.hashtag?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq '.'
      expect(partial.text?).to be_true

      partial = tweet.partials[2]
      expect(partial.content).to eq '#def'
      expect(partial.hashtag?).to be_true
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('Lorem ipsum @abc/def')
      expect(tweet.partials.length).to eq 2

      partial = tweet.partials[0]
      expect(partial.content).to eq 'Lorem ipsum '
      expect(partial.text?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq '@abc/def'
      expect(partial.list?).to be_true
    end
    it 'breaks tweet into partials' do
      tweet = Bluebird::Tweet.new('Lorem #ipsum @dolor')
      expect(tweet.partials.length).to eq 4

      partial = tweet.partials[0]
      expect(partial.content).to eq 'Lorem '
      expect(partial.text?).to be_true

      partial = tweet.partials[1]
      expect(partial.content).to eq '#ipsum'
      expect(partial.hashtag?).to be_true

      partial = tweet.partials[2]
      expect(partial.content).to eq ' '
      expect(partial.text?).to be_true

      partial = tweet.partials[3]
      expect(partial.content).to eq '@dolor'
      expect(partial.mention?).to be_true
    end
  end

  describe '#add_partial' do

    it 'sets the partial type' do
      tweet = Bluebird::Tweet.new('Lorem ipsum dolor')
      tweet.add_partial(' sit amet', :sit_amet)
      expect(tweet.partials.last.partial_type).to be :sit_amet
    end

    context 'When there is no partials' do
      it 'adds a new partial to the end of the tweet' do
        tweet = Bluebird::Tweet.new('')
        tweet.add_partial('Lorem ipsum', :text)
        expect(tweet.partials.length).to be 1
        partial = tweet.partials.first
        expect(partial.prev_partial).to be nil
        expect(partial.next_partial).to be nil
      end
    end

    context 'When there is already one partial' do
      it 'adds a new partial to the end of the tweet' do
        tweet = Bluebird::Tweet.new('Lorem ipsum dolor')
        expect(tweet.partials.length).to eq 1
        tweet.add_partial(' sit amet', :text)
        expect(tweet.partials.length).to eq 2
        expect(tweet.partials.last.content).to eq ' sit amet'
      end
      it 'sets the next_partial of the first partial' do
        tweet = Bluebird::Tweet.new('Lorem ipsum dolor')
        first_partial = tweet.partials.first
        tweet.add_partial(' sit amet', :sit_amet)
        last_partial = tweet.partials.last
        expect(first_partial.prev_partial).to be nil
        expect(first_partial.next_partial).to be last_partial
      end
      it 'sets the prev_partial of the new partial' do
        tweet = Bluebird::Tweet.new('Lorem ipsum dolor')
        first_partial = tweet.partials.first
        tweet.add_partial(' sit amet', :sit_amet)
        last_partial = tweet.partials.last
        expect(last_partial.prev_partial).to be first_partial
        expect(last_partial.next_partial).to be nil
      end
    end
  end
end
