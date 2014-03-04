module Bluebird
  class Config

    @strategies                    = [:strip, :squeeze, :truncate]
    @max_length                    = 140
    @characters_reserved_per_media = 23
    @short_url_length_https        = 23
    @short_url_length              = 22

    class << self
      attr_accessor :strategies, :max_length, :characters_reserved_per_media, :short_url_length_https, :short_url_length

      def register(name, klass)
        singleton_class.send(:attr_accessor, name)
        send("#{name}=", klass)
      end

    end

  end
end
