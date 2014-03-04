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
end
