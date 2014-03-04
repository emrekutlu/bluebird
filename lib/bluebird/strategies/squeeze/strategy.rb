module Bluebird
  module Strategies
    module Squeeze
      class Strategy < Bluebird::Strategies::Base
        class << self

          def run(tweet, config)
            if run?(tweet, config.max_length)
              squeeze(tweet)
            end
          end

          private

          def run?(tweet, max)
            tweet.length > max
          end

          def squeeze(tweet)
            tweet.text_partials.each do |partial|
              partial.content.squeeze!(' ')
            end
          end

        end
      end
    end
  end
end
