module Bluebird
  module Strategies
    module Via
      class Strategy < Bluebird::Strategies::Base
        class << self

          def run(tweet, config)
            if run?(config.via.username)
              tweet.add_partial(text(config.via), :via)
            end
          end

          private

          def run?(username)
            username_exists?(username) ? true : raise('Bluebird: config.via.username is missing.')
          end

          def text(via_config)
            " #{via_config.prefix} @#{via_config.username}"
          end

          def username_exists?(username)
            if username
              username.strip!
              !username.eql?('')
            else
              false
            end
          end

        end
      end
    end
  end
end
