module Bluebird
  module Strategies
    module Via
      class Strategy < Bluebird::Strategies::Base
        class << self

          def run(tweet, config)
            if run?(config.via.username)
              add_separator(tweet)
              tweet.add_partial(text(config.via), :via)
            end
          end

          private

          def run?(username)
            username_exists?(username) ? true : raise('Bluebird: config.via.username is missing.')
          end

          def add_separator(tweet)
            if add_separator?(tweet)
              add_separator_partial?(tweet) ? add_separator_partial(tweet) : add_space_to_last_partial(tweet)
            end
          end

          def text(via_config)
            "#{via_config.prefix} @#{via_config.username}"
          end

          def username_exists?(username)
            if username
              username.strip!
              !username.eql?('')
            else
              false
            end
          end

          def add_separator_partial?(tweet)
            !tweet.partials.last.text?
          end

          def add_separator?(tweet)
            tweet.partials.length > 0
          end

          def add_separator_partial(tweet)
            tweet.add_partial(' ', :text)
          end

          def add_space_to_last_partial(tweet)
            last = tweet.partials.last
            unless last.content.end_with?(' ')
              last.content += ' '
            end
          end

        end
      end
    end
  end
end
