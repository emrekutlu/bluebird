module Bluebird
  module Strategies
    class Base
      class << self

        def run(tweet, config)
          raise NotImplementedError
        end

      end
    end
  end
end
