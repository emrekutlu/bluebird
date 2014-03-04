module Bluebird
  module Strategies
    module Strip
      class Strategy < Bluebird::Strategies::Base
        class << self

          def run(tweet, config)
            if run?(tweet, config.max_length)
              strip(tweet)
            end
          end

          private

          def run?(tweet, max)
            tweet.length > max
          end

          def strip(tweet)
            first = tweet.partials.first
            last  = tweet.partials.last

            first.content.lstrip! if first.text?
            last.content.rstrip! if last.text?
          end

        end
      end
    end
  end
end
