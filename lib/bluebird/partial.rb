module Bluebird
  class Partial

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

    def first?
      !prev_partial
    end

    def last?
      !next_partial
    end

    def text?
      @partial_type.eql?(:text)
    end

    def mention?
      @partial_type.eql?(:mention)
    end

    def list?
      @partial_type.eql?(:list)
    end

    def url?
      @partial_type.eql?(:url)
    end

    def hashtag?
      @partial_type.eql?(:hashtag)
    end

    def cashtag?
      @partial_type.eql?(:cashtag)
    end

    def entity?
      !text?
    end

    def separator?
      # separates two entities
      # ex: @iekutlu and @mekanio => " and " is a separater
      prev_partial && prev_partial.entity? && next_partial && next_partial.entity?
    end

    def reply_preventer?
      first? && next_partial && next_partial.mention?
    end

    def https?
      url? && content.start_with?('https://')
    end

  end
end
