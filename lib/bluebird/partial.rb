module Bluebird
  # A partial is a part of a {Tweet}. Partials have different types. These are the default types; text, mention, list, url, hashtag, cashtag.
  # Strategies can add different types of partials. See {Bluebird::Strategies::Via::Strategy} for an example.
  #
  #   tweet = Bluebird::Tweet.new("The #bluebirds are a group of medium-sized birds http://en.wikipedia.org/wiki/Bluebird")
  class Partial

    attr_reader   :partial_type
    attr_accessor :content, :prev_partial, :next_partial

    def initialize(content, partial_type)
      @content      = content
      @partial_type = partial_type
    end

    def length
      if url?
        https? ? Config.short_url_length_https : Config.short_url_length
      else
        content.char_length
      end
    end

    # @return [Boolean]
    def first?
      !prev_partial
    end

    # @return [Boolean]
    def last?
      !next_partial
    end

    # @return [Boolean]
    def text?
      @partial_type.eql?(:text)
    end

    # @return [Boolean]
    def mention?
      @partial_type.eql?(:mention)
    end

    # @return [Boolean]
    def list?
      @partial_type.eql?(:list)
    end

    # @return [Boolean]
    def url?
      @partial_type.eql?(:url)
    end

    # @return [Boolean]
    def hashtag?
      @partial_type.eql?(:hashtag)
    end

    # @return [Boolean]
    def cashtag?
      @partial_type.eql?(:cashtag)
    end

    # @return [Boolean]
    def entity?
      !text?
    end

    # @return [Boolean]
    def separator?
      # separates two entities
      # ex: @iekutlu and @mekanio => " and " is a separater
      prev_partial && prev_partial.entity? && next_partial && next_partial.entity?
    end

    # @return [Boolean]
    def reply_preventer?
      first? && next_partial && next_partial.mention?
    end

    # @return [Boolean]
    def https?
      url? && content.start_with?('https://')
    end

  end
end
