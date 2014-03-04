module Bluebird
  class Tweet

    include Twitter::Extractor

    attr_reader :partials, :original_status, :media

    def initialize(status, opts = {})
      @original_status = status
      @partials = extract_partials(status)
      @media = opts[:media] if opts.has_key?(:media)
    end

    def status
      partials.map { |partial| partial.content }.join
    end

    def length
      total_partial_length + media_length
    end

    def text_partials
      partials.select { |partial| partial.text? }
    end

    def url_partials
      partials.select { |partial| partial.url? }
    end

    def mention_partials
      partials.select { |partial| partial.mention? }
    end

    def hashtag_partials
      partials.select { |partial| partial.hashtag? }
    end

    def cashtag_partials
      partials.select { |partial| partial.cashtag? }
    end

    private

    def total_partial_length
      total = 0

      partials.each do |partial|
        total += partial.length
      end

      total
    end

    def media_length
      media ? Config.characters_reserved_per_media : 0
    end

    def extract_partials(status)
      entities = extract_entities_with_indices(status, extract_url_without_protocol: true)
      length   = status.char_length
      index    = 0
      partials = []

      entities.each do |entity|
        first = entity[:indices].first
        last  = entity[:indices].last

        add_partial(partials, status[index, first - index], :text)
        add_partial(partials, status[first, last - first], entity_type(entity))

        index = last
      end

      if ending_partial?(index, length)
        add_partial(partials, status[index, length - index], :text)
      end

      partials
    end

    def add_partial(partials, content, partial_type)
      if eligible_content?(content)
        partial = Partial.new(content, partial_type)

        if (last = partials.last)
          last.next_partial = partial
          partial.prev_partial = last
        end

        partials << partial
      end
    end

    def entity_type(entity)
      if entity.has_key?(:screen_name)
        entity[:list_slug].empty? ? :mention : :list
      elsif entity.has_key?(:hashtag)
        :hashtag
      elsif entity.has_key?(:url)
        :url
      elsif entity.has_key?(:cashtag)
        :cashtag
      end
    end

    def ending_partial?(index, length)
      index <= length
    end

    def eligible_content?(content)
      content.char_length > 0
    end

  end
end
